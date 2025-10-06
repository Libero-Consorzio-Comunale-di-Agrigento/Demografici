package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivRichiamoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivRichiamoComposizione
import it.finmatica.de4gsdzk.statocivile.CivRichiamoFormula
import it.finmatica.de4gsdzk.statocivile.CivRichiamoFormulaService
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

/**
 * ViewModel child per {@link CivRichiamoFormula} che dipende sempre da un parent
 * (per es. {@link RichiamoComposizioneDettaglioViewModel})
 */
@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RichiamoFormulaListaViewModel extends DizionarioListaViewModel {

    List<CivRichiamoFormula> lista

    CivRichiamoFormula dettaglio

    CivRichiamoComposizione richiamoComposizione
    Component opener

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CivRichiamoFormulaService civRichiamoFormulaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("richiamoComposizione") CivRichiamoComposizione richiamoComposizione, @ExecutionArgParam("opener") Component opener) {

        self = w

        pagingEnabled = false
        modifyEnabled = true
        deleteEnabled = true
        //searchEnabled = true

        this.richiamoComposizione = richiamoComposizione
        this.opener = opener

        List<Map<String, String>> eList = [Etichette.Testo, Etichette.Richiami_Formule, EtichetteMessaggi.Ask_Cancellazione_associazione_formula]
        eList.addAll(CivRichiamoBaseDomain.etichetteDomain)
        eList.addAll(CivRichiamoFormula.etichetteDomain)
        eList.addAll(CivFormulaAnnotazione.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Richiami_Formule)

        resize()

        caricaLista()
    }

    @Override
    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    @Override
    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        List<CivRichiamoFormula> l = []
        if (richiamoComposizione != null) {
            l = civRichiamoFormulaService.listAllByTipoAttoAndRichiamoAndProgressivoAndFiltroLike(richiamoComposizione.tipoAtto, richiamoComposizione.richiamo, richiamoComposizione.progressivo, (SqlUtils.beginsAndEndsLike(filtro)?:"%"))
        }
        return new Paginazione(l, l.size())
    }

    String getUriDettaglio(){
        return "dizionari/tipoAtto/richiamoFormulaDettaglio.zul"
    }

    @Command void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), opener, [id: dettaglio.id, richiamoComposizione: richiamoComposizione])
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onInserisci() {
        if (addEnabled && userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), opener, [richiamoComposizione: richiamoComposizione])
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio?.formula) {
            return String.format(getEtichetta(EtichetteMessaggi.Ask_Cancellazione_associazione_formula), dettaglio.formula.descrizioneEstesa)
        }
        return ""
    }

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            civRichiamoFormulaService.delete(dettaglio)
            onRicarica()
        }
    }
}