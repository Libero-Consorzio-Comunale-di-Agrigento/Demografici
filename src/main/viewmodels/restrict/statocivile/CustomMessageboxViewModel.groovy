package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.utils.CustomEvents
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CustomMessageboxViewModel {

    Window self

    String titolo
    String msg
    List<Map> listaOpzioni
    Map params

    Map etichette = [:]

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("titolo") String titolo, @ExecutionArgParam("msg") String msg
               , @ExecutionArgParam("listaOpzioni") List<Map> listaOpzioni, @ExecutionArgParam("params") Map params) {

        self = w

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(listaOpzioni)

        this.titolo = titolo
        this.msg = msg

        this.listaOpzioni = listaOpzioni

        this.params = params
    }

    @Command void onSeleziona (@BindingParam("opzione") Map opzione) {
        Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, [opzione:opzione, params:params] )
        onChiudi()
    }

    @Command void onChiudi () {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

}
