package restrict.statocivile.dizionari.comunicazioni

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
class ComunicazioneViewModel extends AbstractTabNavigatorViewModel {

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map> eList = [Etichette.getEtichetta("Enti"), Etichette.getEtichetta("Comunicazioni"), Etichette.getEtichetta("Comunicazioni_Ente"),
                           Etichette.getEtichetta("Parametri_Protocollo"), Etichette.getEtichetta("Tipi_Documento_Fascicolo"), Etichette.getEtichetta("Formule_CIA")]

        doInit(w, eList)

        resize()
    }

}
