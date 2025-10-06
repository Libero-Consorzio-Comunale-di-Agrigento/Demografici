package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DocumentoIndividuoListaViewModel extends AbstractDocumentoIndividuoListaViewModel {

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.Documenti_Individuo, Etichette.Storico_tooltip, Etichette.Ordina_per]

        doInit(w, eList)

        msgTitle = getEtichetta(Etichette.Documenti_Individuo)

        formLabel = msgTitle?.toUpperCase()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page p = anaDocumentoService.listRecentiByAnagrafe(individuoCorrente, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    @Command
    void onOpenStorico() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/documentoIndividuoStoricoLista.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form famiglia allegati", ex)
            throw ex
        }
    }

}
