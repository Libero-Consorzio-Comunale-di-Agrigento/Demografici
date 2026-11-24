package restrict.anagrafe.dizionari.configurazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractTabNavigatorViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ConfigurazioneViewModel extends AbstractTabNavigatorViewModel {

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map> eList = [Etichette.getEtichetta("Parametri"), Etichette.getEtichetta("Loghi"), Etichette.getEtichetta("Log")]

        doInit(w, eList)

        resize()
    }

}
