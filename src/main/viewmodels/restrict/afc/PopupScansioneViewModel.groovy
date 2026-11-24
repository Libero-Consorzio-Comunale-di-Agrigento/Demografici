package restrict.afc

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@VariableResolver(DelegatingVariableResolver)
class PopupScansioneViewModel {

    Window self
    String urlScansione

    String nomeFileScansionato
    String nomeFileScansionatoPlaceholder

    Map<String, String> etichette = [:]

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    void init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("urlScansione") String urlScansione, @ExecutionArgParam("nomeFileScansionatoPlaceholder") String nomeFileScansionatoPlaceholder) {
        this.self = w
        this.urlScansione = urlScansione
        this.nomeFileScansionatoPlaceholder = nomeFileScansionatoPlaceholder

        List<Map<String, String>> eList = [Etichette.getEtichetta("Scansione"), Etichette.getEtichetta("Chiudi")]
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)
    }

    @Command void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [nomeFileScansionato: nomeFileScansionato])
    }
}
