package restrict.statocivile.dizionari.comunicazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioneFormulaListaViewModel extends ComunicazioneBaseDomainListaParentViewModel<CivComunicazioneFormula> {

    @WireVariable
    private CivComunicazioneService civComunicazioneService

    @WireVariable
    private CivComunicazioneFormulaService civComunicazioneFormulaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("comunicazione") CivComunicazione comunicazione,
               @ExecutionArgParam("opener") Component opener) {

        searchEnabled = true

        List<Map<String, String>> eList = [Etichette.Comunicazioni_Formula]

        eList.addAll(CivComunicazioneRelazione2BaseDomain.etichetteDomain)
        doInit(w, eList)

        // Devo ricaricare la comunicazione perché l'include prende in maniera statica i parametri
        this.comunicazione = civComunicazioneService.get(comunicazione.id)
        this.opener = opener

        msgTitle = getEtichetta(Etichette.Comunicazioni_Formula)

        caricaLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        Page<CivComunicazioneFormula> p = null
        if (comunicazione) {
            PageRequest pr = new PageRequest(usePaging ? activePage : 0, usePaging ? pageSize : Integer.MAX_VALUE)
            String f = (filtro?SqlUtils.beginsAndEndsLike(filtro):"%")
            p = civComunicazioneFormulaService.listAllByComunicazioneAndFormulaLike(comunicazione, f, pr)
        }
        return new Paginazione(p?.getContent()?:[], p?.getTotalElements()?:0)
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/comunicazione/comunicazioneFormulaDettaglio.zul"
    }

    @Command void onInserisci() {
        if (addEnabled && userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), opener, [comunicazione: comunicazione])
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void eliminaRelazione(CivComunicazioneFormula c){
        if (deleteEnabled && userModifyEnabled) {
            civComunicazioneFormulaService.delete(c)
            onRicarica()
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio?.comunicazione) {
            return (dettaglio.comunicazione.descrizioneEstesa + " - " + dettaglio.formula.descrizioneEstesa + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record))
        }
        return ""
    }

}
