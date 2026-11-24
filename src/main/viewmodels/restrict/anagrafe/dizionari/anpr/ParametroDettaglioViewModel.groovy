package restrict.anagrafe.dizionari.anpr

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnprParametro
import it.finmatica.de4gsdzk.anagrafe.AnprParametroService
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
class ParametroDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    AnprParametro dettaglio

    ETipoOperazione tipoOperazione

    @WireVariable
    private AnprParametroService anprParametroService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Parametro")]
        eList.addAll(AnprParametro.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Parametro"))

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
            dettaglio = anprParametroService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnprParametro(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            AnprParametro c = anprParametroService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.parametro)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

}
