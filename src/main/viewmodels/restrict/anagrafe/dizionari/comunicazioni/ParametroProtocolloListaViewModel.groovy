package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaParametroProtocollo
import it.finmatica.de4gsdzk.anagrafe.AnaParametroProtocolloService
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
class ParametroProtocolloListaViewModel extends DizionarioListaViewModel {

    List<AnaParametroProtocollo> lista
    AnaParametroProtocollo dettaglio

    String codiceFase
    Map<String, String> mapCodiciFase = [:]

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnaParametroProtocolloService anaParametroProtocolloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("showDetailsComunicazioniOnly") Boolean showDetailsComunicazioniOnly) {

        self = w

        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Parametri_Protocollo"), Etichette.getEtichetta("Compilare_funzione")]
        eList.addAll(AnaParametroProtocollo.etichetteDomain)
        eList.addAll(EModalita.values()*.getEtichettaDesc())
        eList.addAll(EInvioProtocollo.values()*.getEtichettaDesc())

        eList.addAll([Etichette.getEtichetta("Riferimento_crescente"), Etichette.getEtichetta("Riferimento_decrescente"),
                      Etichette.getEtichetta("Modello_crescente"), Etichette.getEtichetta("Modello_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Parametri_Protocollo"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        mapCodiciFase = anaParametroProtocolloService.listAllCodiciFase()

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Riferimento_crescente")), [new Sort.Order(Sort.Direction.ASC, "descrizioneFaseAnagrafe")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Riferimento_decrescente")), [new Sort.Order(Sort.Direction.DESC, "descrizioneFaseAnagrafe")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Modello_crescente")), [new Sort.Order(Sort.Direction.ASC, "modello.descrizione")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Modello_decrescente")), [new Sort.Order(Sort.Direction.DESC, "modello.descrizione")])])


        selectedOrder = listaOrder[0]

    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest(usePaging?activePage:0, usePaging?pageSize:Integer.MAX_VALUE, new Sort(selectedOrder?.campi))
        Page<AnaParametroProtocollo> p = anaParametroProtocolloService.listAllByCodiceFase(codiceFase, pr)
        return new Paginazione(p?.getContent()?:[], p?.getTotalElements()?:0)
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/anagrafe/dizionari/comunicazioni/parametroProtocolloDettaglio.zul"
    }

    @Command void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id, codiceFase: dettaglio.codiceFase, descrizioneFase: dettaglio.descrizioneFase])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onInserisci() {
        if (!addEnabled)
            return
        if (userModifyEnabled) {
            if (!codiceFase) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_funzione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                return
            }
            apriDettaglio(getUriDettaglio(), [codiceFase: codiceFase, descrizioneFase: mapCodiciFase[codiceFase]])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio) {
            return getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record"))
        }
        return ""
    }

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            anaParametroProtocolloService.delete(dettaglio)
            onRicarica()
        }
    }

    @Command void onSelectCodiceFase() {
        caricaLista()
    }

}
