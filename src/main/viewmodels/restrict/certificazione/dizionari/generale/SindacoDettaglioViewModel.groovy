package restrict.certificazione.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerSindaco
import it.finmatica.de4gsdzk.certificazione.CerSindacoService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
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
class SindacoDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi{

    CerSindaco dettaglio

    @WireVariable
    private CerSindacoService cerSindacoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id){
        self = w

        backFromRecordEnabled = false
        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Sindaco]
        eList.addAll(CerSindaco.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Sindaco)

        formLabel = msgTitle?.toUpperCase()

        resize()

        // gestione NON standard
        caricaDettaglio(id)
    }

    void caricaDettaglio(def id) {
        List<CerSindaco> l = cerSindacoService.listAllByIdLike(id)
        if (l?.size() == 1){
            dettaglio = l.get(0)
        } else {
            creaDettaglio([:])
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        dettaglio = new CerSindaco(params)
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CerSindaco c = cerSindacoService.save(dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        onCancellaCampo(e)
    }

}
