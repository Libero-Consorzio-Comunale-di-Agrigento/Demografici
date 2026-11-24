package restrict.certificazione.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.OrderBy
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
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

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class TariffaDirittoListaViewModel extends DizionarioListaViewModel {

    List<CerTariffaDiritto> lista
    CerTariffaDiritto dettaglio

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    List<CerCategoriaTipoCertificato> listaCategoriaTipoCertificato = []
    CerCategoriaTipoCertificato selectedCategoria

    @WireVariable
    private CerTariffaDirittoService cerTariffaDirittoService

    @WireVariable
    private CerCategoriaTipoCertificatoService cerCategoriaTipoCertificatoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Tariffe_Diritti")]
        eList.addAll(CerTariffaDiritto.etichetteDomain)
        eList.addAll(EDiritto.values()*.etichettaDesc)

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Tariffe_Diritti"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), [new Sort.Order(Sort.Direction.ASC, "diritto"), new Sort.Order(Sort.Direction.ASC, "fasciaTariffaria")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), [new Sort.Order(Sort.Direction.DESC, "diritto"), new Sort.Order(Sort.Direction.ASC, "fasciaTariffaria")])])

        selectedOrder = listaOrder[0]

        caricaListaCategoriaTipoCertificato()

        caricaLista()
    }

    void caricaListaCategoriaTipoCertificato() {
        listaCategoriaTipoCertificato = [null]

        List<CerCategoriaTipoCertificato> l = cerCategoriaTipoCertificatoService.listAll()
        if (l.size() > 0) {
            listaCategoriaTipoCertificato.addAll(l)
        }

        selectedCategoria = listaCategoriaTipoCertificato.get(0) as CerCategoriaTipoCertificato
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page p = cerTariffaDirittoService.listAllByDescrizioneLikeAndCategoriaTipoCertificato(filtro, selectedCategoria, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/certificazione/dizionari/generale/tariffaDirittoDettaglio.zul"
    }

    @Command
    void onSelectCategoria() {
        onRicarica()
    }

    @Command
    void onInserisci() {
        if (addEnabled) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [:])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command
    void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getMessaggioCancellazione() {
        if (dettaglio) {
            return (dettaglio?.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio) {
            cerTariffaDirittoService.delete(dettaglio)
            onRicarica()
        }
    }

}
