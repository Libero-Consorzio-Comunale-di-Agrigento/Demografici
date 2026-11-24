package restrict.anagrafe.dizionari.generale

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
class DatoGeneraleViewModel extends AbstractTabNavigatorViewModel {

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map> eList = [Etichette.getEtichetta("Titoli_Studio"), Etichette.getEtichetta("Cittadinanze"), Etichette.getEtichetta("Professioni"), Etichette.getEtichetta("Attivita"), Etichette.getEtichetta("Posizioni_Professionali"), Etichette.getEtichetta("Alberi")]

        doInit(w, eList)

        resize()
    }

}
