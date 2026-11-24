package restrict.afc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaMessaggio
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IMessaggio
import it.finmatica.de4gsdzk.utils.Paginazione
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PopupAvvisiViewModel extends AbstractSelectViewModel {

    Window self

    List<IMessaggio> listaAvvisi = []
    List<IMessaggio> listaBloccanti = []


    Map<String, String> etichette = [:]

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("listaMessaggi") List<IMessaggio> listaMessaggi) {
        self = w

        List<Map<String, String>> eList = []
        eList.addAll(Etichette.getEtichetta("Messaggi"))
        eList.addAll(AnaMessaggio.etichetteDomain)
        doInitEtichette(eList)

        this.listaAvvisi = listaMessaggi.findAll { !it.isBloccante() }
        this.listaBloccanti = listaMessaggi.findAll { it.isBloccante() }
    }


    @Override
    void caricaLista() {
        refreshUi()
    }

    @Override
    void resetDettaglio() {
        throw new IllegalStateException("Non dovresti chiamare questo metodo")
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        throw new IllegalStateException("Non dovresti chiamare questo metodo")
    }
}
