package restrict.anagrafe.dizionari.comunicazioni

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
class ComunicazioniViewModel extends AbstractTabNavigatorViewModel {

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map> eList = [
            Etichette.getEtichetta("Comunicazioni"),
            Etichette.getEtichetta("Enti"),
            Etichette.getEtichetta("Modelli"),
            Etichette.getEtichetta("Modelli_Ente"),
            Etichette.getEtichetta("Parametri_Protocollo")
        ]

        doInit(w, eList)

        resize()
    }

}
