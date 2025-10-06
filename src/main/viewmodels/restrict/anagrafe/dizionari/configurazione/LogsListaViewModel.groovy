package restrict.anagrafe.dizionari.configurazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.ETipoLog
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.afc.AbstractLogsListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class LogsListaViewModel extends AbstractLogsListaViewModel {

    List<ETipoLog> listaTipiLog = [ETipoLog.ANPR, ETipoLog.Gsd]

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map<String, String>> eList = []

        doInit(eList)
    }

}
