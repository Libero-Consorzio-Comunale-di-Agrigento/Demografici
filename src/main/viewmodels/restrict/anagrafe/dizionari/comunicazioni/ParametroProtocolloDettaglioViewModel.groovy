package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaParametroProtocollo
import it.finmatica.de4gsdzk.anagrafe.AnaParametroProtocolloService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModello
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

    AnaParametroProtocollo dettaglio

    ETipoOperazione tipoOperazione

    Map<String, String> mapCodiciFaseAnagrafe = [:]

    List<AnaModello> listaModelli = []

    final List<EModalita> listaModalita = [null] + EModalita.values().toList()
    final List<EInvioProtocollo> listaInvioProtocollo = [null] + EInvioProtocollo.values().toList()

    @WireVariable
    private AnaParametroProtocolloService anaParametroProtocolloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("codiceFase") String codiceFase,
               @ExecutionArgParam("descrizioneFase") String descrizioneFase) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Parametro_Protocollo")]
        eList.addAll(AnaParametroProtocollo.etichetteDomain)

        // Aggiungo etichette liste
        eList += EModalita.values()*.getEtichettaDesc() as Map
        eList += EInvioProtocollo.values()*.getEtichettaDesc() as Map

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Parametro_Protocollo"))

        formLabel = msgTitle?.toUpperCase()

        mapCodiciFaseAnagrafe = anaParametroProtocolloService.getMapCodiciAnagrafe(codiceFase)

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([codiceFase: codiceFase, descrizioneFase: descrizioneFase])
            if(mapCodiciFaseAnagrafe.size() == 1) {
                dettaglio.codiceFaseAnagrafe = mapCodiciFaseAnagrafe.keySet().first()
            }
        }

    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anaParametroProtocolloService.get(id)
            tipoOperazione = ETipoOperazione.UPD
            // Carica modelli per il codiceFase corrente
            if (dettaglio.codiceFase) {
                listaModelli = anaParametroProtocolloService.getModelliByCodiceFase(dettaglio.codiceFase)
            }
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaParametroProtocollo(codiceFase: params.codiceFase, descrizioneFase : params.descrizioneFase)
        tipoOperazione = ETipoOperazione.INS
        // Carica modelli per il codiceFase corrente
        if (dettaglio.codiceFase) {
            listaModelli = anaParametroProtocolloService.getModelliByCodiceFase(dettaglio.codiceFase)
        }
    }

    @Command void onCaricaModelli() {
        try {
            final Window w = (Window) Executions.createComponents(
                    "/restrict/anagrafe/dizionari/comunicazioni/modelloSelect.zul",
                    self, [codiceFase: dettaglio.codiceFase])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                dettaglio.modello = (AnaModello) event.data
                anaParametroProtocolloService.calcolaFaseEFunzione(dettaglio)
                refreshUi()
            })
            w.doModal()
        } catch(Exception e) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_campi_obbligatori")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            log.error("Codice Tipo Atto non scelto?", e)
        }
    }

    @Command void onSelezionaTipo() {
        dettaglio.modello = null
        // Ricarica modelli per il nuovo codiceFase
        if (dettaglio.codiceFase) {
            listaModelli = anaParametroProtocolloService.getModelliByCodiceFase(dettaglio.codiceFase)
        }
        //anaParametroProtocolloService.calcolaFaseEFunzione(dettaglio)
        refreshUi()
    }

    @Command void onSalvaRecord() {
        if (dettaglio){
            AnaParametroProtocollo c = anaParametroProtocolloService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
