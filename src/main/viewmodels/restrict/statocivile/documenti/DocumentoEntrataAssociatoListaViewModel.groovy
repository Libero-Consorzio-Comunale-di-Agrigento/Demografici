package restrict.statocivile.documenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiEntrata
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiEntrataService
import it.finmatica.de4gsdzk.utils.ETipoDocumento
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DocumentoEntrataAssociatoListaViewModel extends DocumentoParentListaViewModel {

    /** flag x documenti numerati/non numerati */
    boolean flagNumerati = true

    @WireVariable
    CivVisualizzazioneDocumentiEntrataService civVisualizzazioneDocumentiEntrataService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {

        //excelExportEnabled = true
        //csvExportEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Gestione_Documenti_Entrata")]
        eList.addAll(CivVisualizzazioneDocumentiEntrata.etichetteDomain)

        doInit(w, eList, ETipoDocumento.Entrata)

        addEnabled = true

        msgTitle = getEtichetta(Etichette.getEtichetta("Gestione_Documenti_Entrata"))

        formLabel = msgTitle?.toUpperCase() + " - " + getDescrizioneStato().toUpperCase()

        caricaListaRegistri()
    }

    String getDescrizioneStato(){
        return getEtichetta(Etichette.getEtichetta("Documenti_Associati"))
    }

    void caricaListaAnni() {
        listaAnni = [null] + civVisualizzazioneDocumentiEntrataService.listAllAnniByRegistro(registro)
        anno = null
        onRicarica()
    }

    @Command void onInserisci() {
        if (addEnabled) {
            if (userModifyEnabled) {
                apriDettaglio(uriDettaglioDocumentoEntrata, [registro: registro])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Override Paginazione eseguiQuery(Boolean usePaging) {
        if (registro == null){
            return new Paginazione([], 0)
        } else {
            PageRequest pr = new PageRequest(usePaging?activePage:0, usePaging?pageSize:Integer.MAX_VALUE, new Sort(selectedOrder.campi))
            Page<CivVisualizzazioneDocumentiEntrata> p = civVisualizzazioneDocumentiEntrataService.listAllAssociatiByRegistro(registro, anno, flagNumerati, filtro, pr)
            return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
        }
    }

}
