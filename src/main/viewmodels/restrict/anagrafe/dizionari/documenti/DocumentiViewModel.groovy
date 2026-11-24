package restrict.anagrafe.dizionari.documenti

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
class DocumentiViewModel extends AbstractTabNavigatorViewModel {

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map> eList = [Etichette.getEtichetta("Enti_Emissione"), Etichette.getEtichetta("Tipi_Documento"), Etichette.getEtichetta("Categorie"), Etichette.getEtichetta("Motivi_Rilascio")]

        doInit(w, eList)

        resize()
    }

}
