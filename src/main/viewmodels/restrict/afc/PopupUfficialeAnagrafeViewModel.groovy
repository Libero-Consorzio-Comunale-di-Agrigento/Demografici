package restrict.afc

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractCommonViewModel

@VariableResolver(DelegatingVariableResolver)
class PopupUfficialeAnagrafeViewModel extends AbstractCommonViewModel {

    Window self
    String sorgente

    String ufficialeAnagrafe
    boolean firmaInStampa

    Map<String, String> etichette = [:]

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private UtenteCustomService utenteCustomService
    @WireVariable
    private CerTerminalistaService cerTerminalistaService

    @Init
    void init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("sorgente") String sorgente) {
        this.self = w
        this.sorgente = sorgente

        List<Map> eList = [Etichette.getEtichetta("Stampa"), Etichette.getEtichetta("Salva"), Etichette.getEtichetta("Chiudi")]
        eList.addAll(CerTerminalista.etichetteDomain)
        eList.addAll(Etichette.getEtichetta("Ufficiale_Anagrafe"), Etichette.getEtichetta("Firma"),
                     Etichette.getEtichetta("In_Stampa"))
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        ufficialeAnagrafe = cerTerminalistaService.get(utenteCustomService.getLoggedUserUsername())?.cognomeNome
        firmaInStampa = true
    }

    @Command
    void onSelectUfficialeAnagrafe(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTerminalista) {
            ufficialeAnagrafe = (event.data as CerTerminalista).cognomeNome
        } else {
            ufficialeAnagrafe = null
        }
        refreshUi()
    }

    @Command
    void onChangeUfficialeAnagrafe(@BindingParam("valore") String valore) {
        ufficialeAnagrafe = valore
        refreshUi()
    }

    @Command void onStampa() {
        Events.postEvent(CustomEvents.ON_CLOSE_RELOAD, self, [ufficialeAnagrafe: firmaInStampa ? ufficialeAnagrafe : ""])
        onChiudi()
    }

    @Command void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }
}
