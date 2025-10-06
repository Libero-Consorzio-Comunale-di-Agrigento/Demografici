package restrict.certificazione.dizionari.generale

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
        List<Map> eList = [Etichette.Tipi_Certificato, Etichette.Modalita_rilascio, Etichette.Tipi_firma, Etichette.Terminalisti,
                           Etichette.Motivi_sospensione, Etichette.Tariffe_Diritti,
                           Etichette.Validita, Etichette.Servizi, Etichette.Sindaco]

        doInit(w, eList)

        resize()
    }

}
