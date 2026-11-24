package restrict.certificazione.dizionari.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepUtente
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepUtenteService
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
class UtenteDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    NextStepUtente dettaglio

    ETipoOperazione tipoOperazione

    @WireVariable
    private NextStepUtenteService nextStepUtenteService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Utente")]
        eList.addAll(NextStepUtente.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Utente"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = nextStepUtenteService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new NextStepUtente(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            NextStepUtente c = nextStepUtenteService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

}
