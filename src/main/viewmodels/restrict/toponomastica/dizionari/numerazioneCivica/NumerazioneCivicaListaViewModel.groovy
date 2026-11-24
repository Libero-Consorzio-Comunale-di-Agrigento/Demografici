package restrict.toponomastica.dizionari.numerazioneCivica

import it.finmatica.de4gsdzk.archivi.ArcDatiNumerazioneCivico
import it.finmatica.de4gsdzk.archivi.ArcDatiNumerazioneCivicoService
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.archivi.ArcViaService
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.OrderBy
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Sort
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@VariableResolver(DelegatingVariableResolver.class)
class NumerazioneCivicaListaViewModel extends DizionarioListaViewModel {

    static final String OPZIONE_TUTTE = "TUTTE"
    static final String OPZIONE_PER_COMUNE = "PER COMUNE"

    List<ArcDatiNumerazioneCivico> lista = []
    ArcDatiNumerazioneCivico dettaglio

    List<Object> listaOpzioniVia = []
    Object viaSelezionata = OPZIONE_PER_COMUNE

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private ArcDatiNumerazioneCivicoService arcDatiNumerazioneCivicoService

    @WireVariable
    private ArcViaService arcViaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        pagingEnabled = true
        searchEnabled = true
        addEnabled = false
        modifyEnabled = true
        deleteEnabled = false
        additionalListaToolbarbutton = "/restrict/toponomastica/dizionari/numerazioneCivica/numerazioneCivicaToolbar.zul"

        List<Map<String, String>> eList = [Etichette.getEtichetta("Numerazione_Civica"),
                                           Etichette.getEtichetta("Via"),
                                           Etichette.getEtichetta("Elemento"),
                                           Etichette.getEtichetta("Civico_Esterno"),
                                           Etichette.getEtichetta("Civico_Interno"),
                                           Etichette.getEtichetta("Sequenza"),
                                           Etichette.getEtichetta("Separatore"),
                                           Etichette.getEtichetta("Visibile"),
                                           Etichette.getEtichetta("Default"),
                                           Etichette.getEtichetta("Nessun_dato_disponibile"),
                                           Etichette.getEtichetta("Popola"),
                                           Etichette.getEtichetta("Popola_tooltip"),
                                           Etichette.getEtichetta("Popola_via_non_selezionata"),
                                           Etichette.getEtichetta("Popola_nessun_template"),
                                           Etichette.getEtichetta("Popola_completato")]
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)
        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Numerazione_Civica"))
        formLabel = msgTitle?.toUpperCase()

        caricaOpzioniVia()

        //Ordinamento: raggruppa per civico esterno oppure per civico interno
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Civico_Esterno")), SortUtils.civicoEsternoInternoTutteAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Civico_Interno")), SortUtils.civicoInternoEsternoTutteAsc)])
        selectedOrder = listaOrder[0]

        resize()

        caricaLista()
    }

    void caricaOpzioniVia() {
        listaOpzioniVia = [OPZIONE_PER_COMUNE, OPZIONE_TUTTE]
        listaOpzioniVia.addAll(arcViaService.listAll())
    }

    String getLabelOpzione(Object opz) {
        if (opz instanceof ArcVia) {
            return "${opz.id} - ${opz.denominazione}"
        }
        return opz as String
    }

    boolean isPerComuneMode() {
        return viaSelezionata == OPZIONE_PER_COMUNE
    }

    boolean isColonnaViaNascosta() {
        return isPerComuneMode() || viaSelezionata instanceof ArcVia
    }

    boolean isPopolaEnabled() {
        return viaSelezionata instanceof ArcVia && totalSize == 0
    }

    @Override
    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshLista()
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        Sort sort = new Sort(selectedOrder?.campi ?: SortUtils.civicoEsternoInternoTutteAsc)
        List<ArcDatiNumerazioneCivico> l
        if (isPerComuneMode()) {
            l = arcDatiNumerazioneCivicoService.listPerComune(sort)
        } else if (viaSelezionata instanceof ArcVia) {
            l = arcDatiNumerazioneCivicoService.listPerVia(((ArcVia) viaSelezionata).id, sort)
        } else {
            l = arcDatiNumerazioneCivicoService.listTutte(sort)
        }
        if (filtro) {
            String needle = filtro.toUpperCase()
            l = l.findAll { row ->
                (row.elemento?.toUpperCase()?.contains(needle)) ||
                (row.via?.denominazione?.toUpperCase()?.contains(needle))
            }
        }
        long total = l.size()
        if (usePaging) {
            int from = activePage * pageSize
            if (from >= total) {
                l = []
            } else {
                int to = Math.min(from + pageSize, (int) total)
                l = l.subList(from, to)
            }
        }
        return new Paginazione(l, total)
    }

    @Override
    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    @Override
    String getUriDettaglio() {
        return "/restrict/toponomastica/dizionari/numerazioneCivica/numerazioneCivicaDettaglio.zul"
    }

    @Command
    void onSelectVia() {
        caricaLista()
        BindUtils.postNotifyChange(null, null, this, "perComuneMode")
        BindUtils.postNotifyChange(null, null, this, "colonnaViaNascosta")
        BindUtils.postNotifyChange(null, null, this, "popolaEnabled")
    }

    @Command
    void onPopola() {
        if (!(viaSelezionata instanceof ArcVia)) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Popola_via_non_selezionata")),
                    msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            return
        }
        try {
            int inserted = arcDatiNumerazioneCivicoService.popolaDaTemplate(((ArcVia) viaSelezionata).id)
            if (inserted == 0) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Popola_nessun_template")),
                        msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                return
            }
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Popola_completato")),
                    msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            resetActivePage()
            caricaLista()
            BindUtils.postNotifyChange(null, null, this, "popolaEnabled")
        } catch (De4gsdzkRuntimeException ex) {
            Messagebox.show(ex.message, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command
    void onModifica() {
        if (modifyEnabled && dettaglio) {
            apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
        }
    }

}
