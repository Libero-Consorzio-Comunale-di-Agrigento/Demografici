package restrict.anagrafe.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanzaService
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
class CittadinanzaDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    AnaCittadinanza dettaglio

    ETipoOperazione tipoOperazione

    @WireVariable
    private AnaCittadinanzaService anaCittadinanzaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Cittadinanza")]
        eList.addAll(AnaCittadinanza.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Cittadinanza"))

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
            dettaglio = anaCittadinanzaService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaCittadinanza(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            AnaCittadinanza c = anaCittadinanzaService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.codCi)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

}