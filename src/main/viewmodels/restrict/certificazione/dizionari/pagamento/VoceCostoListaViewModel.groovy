package restrict.certificazione.dizionari.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerTariffaDiritto
import it.finmatica.de4gsdzk.certificazione.EDiritto
import it.finmatica.de4gsdzk.pagamento.EServizioPagamento
import it.finmatica.de4gsdzk.pagamento.IWspaVoceCostoService
import it.finmatica.de4gsdzk.pagamento.WspaVoceCosto
import it.finmatica.de4gsdzk.pagamento.WspaVoceCostoServiceFactory
import it.finmatica.de4gsdzk.pagamento.depag.DepagVoceCosto
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneErroreException
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneNessunElementoException
import it.finmatica.de4gsdzk.utils.*
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
class VoceCostoListaViewModel extends DizionarioListaViewModel {
    private static String ADD_SINCRONIZZA = "ADD_SINCRONIZZA"

    final List<Map> addPlusList = []

    List<WspaVoceCosto> lista
    WspaVoceCosto dettaglio

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    Boolean showDepagColumns

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private ArcParametroService arcParametroService
    @WireVariable
    private WspaVoceCostoServiceFactory wspaVoceCostoServiceFactory
    private IWspaVoceCostoService wspaVoceCostoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        addEnabled = false
        addPlusEnabled = true
        deleteEnabled = false

        List<Map<String, String>> eList = [Etichette.getEtichetta("Voci_di_costo"), Etichette.getEtichetta("Funzione_non_abilitata"), Etichette.getEtichetta("Sincronizza_con_altro"), Etichette.getEtichetta("Tariffe_Diritti")]
        eList.addAll(WspaVoceCosto.etichetteDomain)
        eList.addAll(DepagVoceCosto.etichetteDomain)
        eList.addAll(CerTariffaDiritto.etichetteDomain)
        eList.addAll(Etichette.getEtichetta("Info_Sincronizzazione_successo"))
        eList.addAll(EDiritto.values()*.getEtichettaDesc())

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Voci_di_costo"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), [new Sort.Order(Sort.Direction.ASC, "tariffaDiritto.descrizione")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), [new Sort.Order(Sort.Direction.DESC, "tariffaDiritto.descrizione")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")),  [new Sort.Order(Sort.Direction.ASC, "tariffaDiritto.diritto"), new Sort.Order(Sort.Direction.ASC, "tariffaDiritto.fasciaTariffaria")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), [new Sort.Order(Sort.Direction.DESC, "tariffaDiritto.diritto"), new Sort.Order(Sort.Direction.ASC, "tariffaDiritto.fasciaTariffaria")])])

        selectedOrder = listaOrder[0]

        wspaVoceCostoService = wspaVoceCostoServiceFactory.getService()
        showDepagColumns = arcParametroService.getServizioPagamento() == EServizioPagamento.DEPAG

        addPlusList.add([id: ADD_SINCRONIZZA, idDomain: ADD_SINCRONIZZA, descrizione: String.format(getEtichetta(Etichette.getEtichetta("Sincronizza_con_altro")), getEtichetta(Etichette.getEtichetta("Tariffe_Diritti"))), tipo: "T"])

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

        Page<WspaVoceCosto> p = wspaVoceCostoService.listAllByDescrizioneLike(SqlUtils.beginsAndEndsLike(filtro), pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/certificazione/dizionari/pagamento/voceCostoDettaglio.zul"
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
    void onInserisciPlus(@BindingParam("idDomain") String idDomain) {
        if (addPlusEnabled && userModifyEnabled) {
            if (idDomain == ADD_SINCRONIZZA) {
                try {
                    wspaVoceCostoService.sincronizza()
                    MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.I, getEtichetta(Etichette.getEtichetta("Info_Sincronizzazione_successo")))
                } catch (SincronizzazioneNessunElementoException e) {
                    MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.W, e.message)
                } catch (SincronizzazioneErroreException e) {
                    MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, e.message)
                }
                onRicarica()
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    String getMessaggioCancellazione() {
        if (dettaglio) {
            return (dettaglio.tariffaDiritto.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio) {
            wspaVoceCostoService.delete(dettaglio)
            onRicarica()
        }
    }

}
