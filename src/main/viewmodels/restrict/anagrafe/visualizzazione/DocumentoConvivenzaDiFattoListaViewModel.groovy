package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DocumentoConvivenzaDiFattoListaViewModel extends AbstractDocumentoIndividuoListaViewModel {

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.Documenti_Convivenza_di_Fatto, Etichette.Ordina_per]

        doInit(w, eList)

        msgTitle = getEtichetta(Etichette.Documenti_Convivenza_di_Fatto)

        formLabel = msgTitle?.toUpperCase()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page p = anaDocumentoService.listConvivenzaDiFattoByAnagrafe(individuoCorrente, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

}
