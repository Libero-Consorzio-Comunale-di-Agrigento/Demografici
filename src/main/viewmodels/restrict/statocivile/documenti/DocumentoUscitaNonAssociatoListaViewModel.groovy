package restrict.statocivile.documenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiUscita
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiUscitaService
import it.finmatica.de4gsdzk.utils.ETipoDocumento
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DocumentoUscitaNonAssociatoListaViewModel extends DocumentoParentListaViewModel {

    Boolean flagDtsPresente

    @WireVariable
    private CivVisualizzazioneDocumentiUscitaService civVisualizzazioneDocumentiUscitaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        //excelExportEnabled = true
        //csvExportEnabled = true

        showDetailsProtocollazione = Boolean.FALSE

        List<Map<String, String>> eList = [Etichette.getEtichetta("Gestione_Documenti_Uscita"), Etichette.getEtichetta("Dati_parzialmente_compilati"), Etichette.getEtichetta("Dati_da_compilare")]
        eList.addAll(CivVisualizzazioneDocumentiUscita.etichetteDomain)

        doInit(w, eList, ETipoDocumento.Uscita)

        msgTitle = getEtichetta(Etichette.getEtichetta("Gestione_Documenti_Uscita"))

        formLabel = msgTitle?.toUpperCase() + " - " + getDescrizioneStato()?.toUpperCase()
    }

    String getDescrizioneStato(){
        return getEtichetta(Etichette.getEtichetta("Documenti_Non_Associati"))
    }

    @Override Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest(usePaging?activePage:0, usePaging?pageSize:Integer.MAX_VALUE, new Sort(selectedOrder.campi))
        Page<CivVisualizzazioneDocumentiUscita> p = civVisualizzazioneDocumentiUscitaService.listAllNonAssociatiByDTS(flagDtsPresente, filtro, pr)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

}
