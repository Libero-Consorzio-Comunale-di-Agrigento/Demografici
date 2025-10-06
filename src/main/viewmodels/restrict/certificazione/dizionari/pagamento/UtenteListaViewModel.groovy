package restrict.certificazione.dizionari.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepUtente
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepUtenteService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
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
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class UtenteListaViewModel extends DizionarioListaViewModel{

    List<NextStepUtente> lista
    NextStepUtente dettaglio

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private NextStepUtenteService nextStepUtenteService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.Utenti]
        eList.addAll(NextStepUtente.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Utenti)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        caricaLista()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(SortUtils.idAsc))

        Page p = nextStepUtenteService.listAllByUtenteLike(filtro, pr)

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/certificazione/dizionari/pagamento/utenteDettaglio.zul"
    }

    @Command void onInserisci() {
        if (addEnabled) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [:])
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onModifica() {
        if (modifyEnabled && dettaglio){
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio) {
            return (dettaglio.id  + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record))
        }
        return ""
    }

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            nextStepUtenteService.delete(dettaglio)
            onRicarica()
        }
    }

}
