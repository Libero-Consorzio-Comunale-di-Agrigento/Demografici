package restrict.statocivile.dizionari.comunicazione

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
        List<Map> eList = [Etichette.Enti, Etichette.Comunicazioni, Etichette.Comunicazioni_Ente,
                           Etichette.Parametri_Protocollo, Etichette.Tipi_Documento_Fascicolo, Etichette.Formule_CIA]

        doInit(w, eList)

        resize()
    }

}
