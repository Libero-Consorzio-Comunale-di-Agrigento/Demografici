package restrict.elettorale.dizionari.wsMinisteriali

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
class WsMinisterialiViewModel extends AbstractTabNavigatorViewModel {

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map> eList = [
            Etichette.getEtichetta("Tipi_Elezione"),
            Etichette.getEtichetta("Elezioni_Ws"),
            Etichette.getEtichetta("Sezioni_Archivio"),
            Etichette.getEtichetta("Sezioni_Votanti"),
            Etichette.getEtichetta("Liste_Ws"),
            Etichette.getEtichetta("Candidati_Ws"),
            Etichette.getEtichetta("Comunicazioni_Ws"),
            Etichette.getEtichetta("Rilevamenti"),
            Etichette.getEtichetta("Servizi")
        ]

        doInit(w, eList)

        resize()
    }

}
