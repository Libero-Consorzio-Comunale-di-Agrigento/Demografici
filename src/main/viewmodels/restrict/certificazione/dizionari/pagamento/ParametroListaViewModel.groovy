package restrict.certificazione.dizionari.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.pagamento.IWspaParametroService
import it.finmatica.de4gsdzk.pagamento.WspaParametro
import it.finmatica.de4gsdzk.pagamento.WspaParametroServiceFactory
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
class ParametroListaViewModel extends DizionarioListaViewModel {
    private static String ADD_SINCRONIZZA = "ADD_SINCRONIZZA"

    final List<Map> addPlusList = []

    List<WspaParametro> lista
    WspaParametro dettaglio

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private WspaParametroServiceFactory wspaParametroServiceFactory
    private IWspaParametroService wspaParametroService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        wspaParametroService = wspaParametroServiceFactory.getService()

        self = w

        searchEnabled = true
        addEnabled = false
        addPlusEnabled = true
        deleteEnabled = false

        List<Map<String, String>> eList = [Etichette.getEtichetta("Parametri"), Etichette.getEtichetta("Funzione_non_abilitata"), Etichette.getEtichetta("Sincronizza")]
        eList.addAll(ArcParametro.etichetteDomain)
        eList.addAll(Etichette.getEtichetta("Info_Sincronizzazione_successo"))

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Parametri"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), SortUtils.idAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), SortUtils.idDesc)])

        selectedOrder = listaOrder[0]

        addPlusList.add([id: ADD_SINCRONIZZA, idDomain: ADD_SINCRONIZZA, descrizione: getEtichetta(Etichette.getEtichetta("Sincronizza")), tipo: "T"])

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

        Page<WspaParametro> p = wspaParametroService.listAllByDescrizioneLike(SqlUtils.beginsAndEndsLike(filtro), pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/certificazione/dizionari/pagamento/parametroDettaglio.zul"
    }

    @Command
    void onModifica() {
        if (modifyEnabled && dettaglio?.flagVisibile) {
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
                    wspaParametroService.sincronizza()
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
            return (dettaglio.id + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio?.flagVisibile) {
            wspaParametroService.delete(dettaglio)
            onRicarica()
        }
    }

}
