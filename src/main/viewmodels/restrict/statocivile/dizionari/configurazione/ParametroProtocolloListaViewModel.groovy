package restrict.statocivile.dizionari.configurazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ParametroProtocolloDiz
import it.finmatica.de4gsdzk.statocivile.CivParametroProtocollo
import it.finmatica.de4gsdzk.statocivile.CivParametroProtocolloService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
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

    List<CivParametroProtocollo> lista
    CivParametroProtocollo dettaglio

    Boolean showDetailsComunicazioniOnly

    String codiceFase
    Map<String, String> mapCodiciFase = [:]

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CivParametroProtocolloService civParametroProtocolloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("showDetailsComunicazioniOnly") Boolean showDetailsComunicazioniOnly) {

        self = w

        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.Parametri_Protocollo, EtichetteMessaggi.Compilare_funzione]
        eList.addAll(CivParametroProtocollo.etichetteDomain)
        eList.addAll(EModalita.values()*.getEtichettaDesc())
        eList.addAll(EInvioProtocollo.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Parametri_Protocollo)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        this.showDetailsComunicazioniOnly = (showDetailsComunicazioniOnly?:Boolean.FALSE)
        if (showDetailsComunicazioniOnly){
            codiceFase = ParametroProtocolloDiz.CODICE_FASE_W
            onSelectCodiceFase()
        } else {
            // Lista dei codici fase
            mapCodiciFase = civParametroProtocolloService.listAllCodiciFase()
        }
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest(usePaging?activePage:0, usePaging?pageSize:Integer.MAX_VALUE)
        Page<CivParametroProtocollo> p = civParametroProtocolloService.listAllByCodiceFase(codiceFase, pr)
        return new Paginazione(p?.getContent()?:[], p?.getTotalElements()?:0)
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/configurazione/parametroProtocolloDettaglio.zul"
    }

    @Command void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id, codiceFase: dettaglio.codiceFase, descrizioneFase: dettaglio.descrizioneFase])
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onInserisci() {
        if (!addEnabled)
            return
        if (userModifyEnabled) {
            if (!codiceFase) {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_funzione), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                return
            }
            apriDettaglio(getUriDettaglio(), [codiceFase: codiceFase, descrizioneFase: mapCodiciFase[codiceFase]])
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio) {
            return getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record)
        }
        return ""
    }

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            civParametroProtocolloService.delete(dettaglio)
            onRicarica()
        }
    }

    @Command void onSelectCodiceFase() {
        caricaLista()
    }

    boolean isComunicazione() {
        codiceFase == ParametroProtocolloDiz.CODICE_FASE_W
    }

}
