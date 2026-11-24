package restrict.anagrafe.dizionari

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnte
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnteService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.OrderBy
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class EnteListaViewModel extends DizionarioListaViewModel {

    AnaEnte dettaglio
    List<AnaEnte> lista
    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnaEnteService anaEnteService

    boolean sezioneComunicazioni

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionParam('comunicazioni') Boolean comunicazioni) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Enti_Emissione"), Etichette.getEtichetta("Enti"), Etichette.getEtichetta("Funzione_non_abilitata")]
        eList.addAll(AnaEnte.etichetteDomain)
        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        sezioneComunicazioni = comunicazioni

        msgTitle = sezioneComunicazioni ? getEtichetta(Etichette.getEtichetta("Enti")) : getEtichetta(Etichette.getEtichetta("Enti_Emissione"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), SortUtils.idAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), SortUtils.idDesc)])

        selectedOrder = listaOrder[0]

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
        boolean siglaNull = !sezioneComunicazioni
        Page<AnaEnte> p = anaEnteService.listAllByFiltroLike(filtro, siglaNull, pr)
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/anagrafe/dizionari/enteDettaglio.zul"
    }

    @Command onInserisci() {
        if (addEnabled && userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), [comunicazioni: sezioneComunicazioni])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.codice, comunicazioni: sezioneComunicazioni])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio) {
            return (dettaglio?.descrizione  + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio) {
            anaEnteService.delete(dettaglio)
            onRicarica()
        }
    }
}
