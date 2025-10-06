package restrict.statocivile.dizionari.configurazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivParametroProtocollo
import it.finmatica.de4gsdzk.statocivile.CivParametroProtocolloService
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ParametroProtocolloDettaglioViewModel extends DizionarioDettaglioViewModel {

    CivParametroProtocollo dettaglio

    ETipoOperazione tipoOperazione

    Map<String, String> mapCodiciTipoAtto = [:]

    final List<EModalita> listaModalita = [null] + EModalita.values().toList()
    final List<EInvioProtocollo> listaInvioProtocollo = [null] + EInvioProtocollo.values().toList()

    @WireVariable
    private CivParametroProtocolloService civParametroProtocolloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("codiceFase") String codiceFase,
               @ExecutionArgParam("descrizioneFase") String descrizioneFase) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Parametro_Protocollo]
        eList.addAll(CivParametroProtocollo.etichetteDomain)

        // Aggiungo etichette liste
        eList += EModalita.values()*.getEtichettaDesc() as Map
        eList += EInvioProtocollo.values()*.getEtichettaDesc() as Map

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Parametro_Protocollo)

        formLabel = msgTitle?.toUpperCase()

        mapCodiciTipoAtto = civParametroProtocolloService.getMapCodiciTipoAtto(codiceFase)

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([codiceFase: codiceFase, descrizioneFase:descrizioneFase])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = civParametroProtocolloService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new CivParametroProtocollo(codiceFase: params.codiceFase, descrizioneFase:params.descrizioneFase)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command void onCaricaComunicazioni() {
        try {
            final int codice = Integer.parseInt(dettaglio.codiceTipoAtto)
            final Window w = (Window) Executions.createComponents(
                    "/restrict/statocivile/comunicazioneSelect.zul",
                    self, [codiceTipoAtto: codice])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                dettaglio.comunicazione = (CivComunicazione) event.data
                civParametroProtocolloService.calcolaFaseEFunzione(dettaglio)
                refreshUi()
            })
            w.doModal()
        } catch(Exception e) {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_campi_obbligatori), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            log.error("Codice Tipo Atto non scelto?", e)
        }
    }

    @Command void onSelezionaTipo() {
        dettaglio.comunicazione = null
        civParametroProtocolloService.calcolaFaseEFunzione(dettaglio)
        refreshUi()
    }

    @Command void onSalvaRecord() {
        if (dettaglio){
            CivParametroProtocollo c = civParametroProtocolloService.save(dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
