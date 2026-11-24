package restrict.certificazione.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerValiditaCertificato
import it.finmatica.de4gsdzk.certificazione.CerValiditaCertificatoService
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
class ValiditaCertificatoDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi{

    CerValiditaCertificato dettaglio

    ETipoOperazione tipoOperazione

    @WireVariable
    private CerValiditaCertificatoService cerValiditaCertificatoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Validita")]
        eList.addAll(CerValiditaCertificato.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Validita"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null){
            dettaglio = cerValiditaCertificatoService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        dettaglio = new CerValiditaCertificato(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CerValiditaCertificato c = cerValiditaCertificatoService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        onCancellaCampo(e)
    }

}
