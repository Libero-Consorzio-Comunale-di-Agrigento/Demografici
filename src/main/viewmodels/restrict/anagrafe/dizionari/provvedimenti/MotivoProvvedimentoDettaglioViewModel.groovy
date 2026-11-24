package restrict.anagrafe.dizionari.provvedimenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaMotivoProvvedimento
import it.finmatica.de4gsdzk.anagrafe.AnaMotivoProvvedimentoService
import it.finmatica.de4gsdzk.anagrafe.ETipoDivorzioProvvedimento
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
class MotivoProvvedimentoDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    AnaMotivoProvvedimento dettaglio

    ETipoOperazione tipoOperazione

    List<ETipoDivorzioProvvedimento> listaTipoDivorzio = ETipoDivorzioProvvedimento.values() as List

    @WireVariable
    private AnaMotivoProvvedimentoService anaMotivoProvvedimentoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Motivo_Provvedimento"), Etichette.getEtichetta("Certificazione_tooltip")]
        eList.addAll(AnaMotivoProvvedimento.etichetteDomain)
        eList.addAll(ETipoDivorzioProvvedimento.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Motivo_Provvedimento"))

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
            dettaglio = anaMotivoProvvedimentoService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaMotivoProvvedimento(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            AnaMotivoProvvedimento c = anaMotivoProvvedimentoService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.codice)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

}