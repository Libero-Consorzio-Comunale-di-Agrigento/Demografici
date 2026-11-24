package restrict.statocivile.dizionari.configurazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractTabNavigatorViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ConfigurazioneViewModel extends AbstractTabNavigatorViewModel {

    Boolean attivaGestioneEtichette

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map> eList = [Etichette.getEtichetta("Parametri"), Etichette.getEtichetta("Etichette"), Etichette.getEtichetta("Parametri_Protocollo"), Etichette.getEtichetta("Loghi"), Etichette.getEtichetta("Log")]

        doInit(w, eList)

        attivaGestioneEtichette = arcParametroService.isGestioneMultilingueAttiva()

        resize()
    }

}
