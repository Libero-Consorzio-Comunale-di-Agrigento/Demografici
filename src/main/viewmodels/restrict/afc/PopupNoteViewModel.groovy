package restrict.afc

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.allegati.IAllegato
import it.finmatica.de4gsdzk.allegati.IAllegatoService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.statocivile.CivFascicoloAttoAllegato
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.context.ApplicationContext
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@VariableResolver(DelegatingVariableResolver)
class PopupNoteViewModel {

    Window self

    IAllegato dettaglio
    IAllegatoService allegatoService

    Map<String, String> etichette = [:]

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    void init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("allegato") IAllegato allegato, @ExecutionArgParam("serviceBeanName") String serviceBeanName) {
        this.self = w

        this.dettaglio = allegato
        //Recupero il service che mi per questo particolare contesto
        this.allegatoService = Holders.getApplicationContext().getBean(serviceBeanName, IAllegatoService)

        List<Map> eList = [Etichette.getEtichetta("Salva"), Etichette.getEtichetta("Chiudi")]
        eList.addAll(CivFascicoloAttoAllegato.etichetteDomain)
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)
    }

    @Command void onSalva() {
        allegatoService.updateNote(dettaglio.id, dettaglio.note)
        Events.postEvent(CustomEvents.ON_CLOSE_RELOAD, self, [:])
        onChiudi()
    }

    @Command void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }
}
