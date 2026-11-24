package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.Ad4UtentiGsd
import it.finmatica.de4gsdzk.Ad4UtentiGsdService
import it.finmatica.de4gsdzk.ansc.AnscUtente
import it.finmatica.de4gsdzk.ansc.AnscUtenteService
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnscUtenteDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    AnscUtente dettaglio

    ETipoOperazione tipoOperazione

    List<Ad4UtentiGsd> utenti
    Ad4UtentiGsd utenteSelected

    @WireVariable
    private AnscUtenteService anscUtenteService
    @WireVariable
    private Ad4UtentiGsdService ad4UtentiGsdService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = AnscUtente.etichetteDomain

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Utenti_ANSC"))

        formLabel = msgTitle?.toUpperCase()

        utenti = ad4UtentiGsdService.listAll()

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anscUtenteService.get(id)
            utenteSelected = utenti.find { (it.utente == dettaglio.id) }
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshDettaglio()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnscUtente(params)
        tipoOperazione = ETipoOperazione.INS
    }

    Boolean isUserModifyEnabled() {
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            AnscUtente c = anscUtenteService.save(tipoOperazione, dettaglio, true)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

    @Command
    void selezionaUtente() {
        dettaglio.id = utenteSelected.utente
        dettaglio.cognome = utenteSelected.cognome
        dettaglio.nome = utenteSelected.nome
        refreshUi()
    }

}