package restrict.statocivile.dizionari.ansc

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
class AnscViewModel extends AbstractTabNavigatorViewModel {

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map> eList = [Etichette.getEtichetta("Parametri"), Etichette.getEtichetta("Servizi"),
                           Etichette.getEtichetta("Casi_Uso_Servizi"), Etichette.getEtichetta("Casi_Uso_Allegati"),
                           Etichette.getEtichetta("Motivi_richiesta"), Etichette.getEtichetta("Utenti")]

        doInit(w, eList)

        resize()
    }
}
