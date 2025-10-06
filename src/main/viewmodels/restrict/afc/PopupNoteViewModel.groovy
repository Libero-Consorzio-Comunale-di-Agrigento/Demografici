package restrict.afc

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.statocivile.CivFascicoloAttoAllegato
import it.finmatica.de4gsdzk.statocivile.CivFascicoloAttoAllegatoService
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@VariableResolver(DelegatingVariableResolver)
class PopupNoteViewModel {

    Window self

    CivFascicoloAttoAllegato dettaglio

    Map<String, String> etichette = [:]

    @WireVariable
    private CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    void init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("fascicoloAllegato") CivFascicoloAttoAllegato fascicoloAllegato) {
        this.self = w

        this.dettaglio = fascicoloAllegato

        List<Map> eList = [Etichette.Salva, Etichette.Chiudi]
        eList.addAll(CivFascicoloAttoAllegato.etichetteDomain)
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)
    }

    @Command void onSalva() {
        civFascicoloAttoAllegatoService.updateNote(dettaglio.id, dettaglio.note)
        Events.postEvent(CustomEvents.ON_CLOSE_RELOAD, self, [:])
        onChiudi()
    }

    @Command void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }
}
