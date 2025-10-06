package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazioneService
import it.finmatica.de4gsdzk.statocivile.CivRichiamoFormula
import it.finmatica.de4gsdzk.statocivile.CivRichiamoFormulaService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.dizionari.FormulaListaParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FormulaComposizioneListaViewModel extends FormulaListaParentViewModel {

    Tuple2<CivFormulaAnnotazione, List<CivRichiamoFormula>> dettaglio

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @WireVariable
    private CivRichiamoFormulaService civRichiamoFormulaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {

        listaTipoAnnotazione = [ETipoAnnotazione.A, ETipoAnnotazione.W]

        listaTipiAtto = TipoAttoUtils.listaTipiAttoDefault

        doInit(w, [Etichette.Formule_Composizione, Etichette.Richiami, Etichette.Richiamo, Etichette.Progressivo])

        msgTitle = getEtichetta(Etichette.Formule_Composizione)

        formLabel = msgTitle?.toUpperCase()
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "dizionari/tipoAtto/formulaComposizioneDettaglio.zul"
    }

    Paginazione eseguiQuery(Boolean usePaging){
        List l = []
        long tot = 0
        if (tipoAttoEnum != null){
            Map params = [activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                          tipoAtto: new Integer(tipoAttoEnum.valore), tipiAnnotazione:listaTipoAnnotazione,
                          tipoOrdinamento: tipoOrdinamentoSelezionato, filtro: filtro, order: selectedOrder?.campi]

            Page<CivFormulaAnnotazione> p = civFormulaAnnotazioneService.list(params)
            if (p?.getContent()){
                for (CivFormulaAnnotazione fc: p?.getContent()){
                    List<CivRichiamoFormula> richiamiFormula = (civRichiamoFormulaService.listAllByTipoAttoAndFormula(new Integer(tipoAttoEnum.valore), fc)?:[])
                    l.add(new Tuple2(fc, richiamiFormula))
                }
            }
            tot = (p?.getTotalElements()?:0)
        } else {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
        return new Paginazione(l, tot)
    }

    @Command void onModifica() {
        if (modifyAnnotazioneEnabled && userModifyEnabled && dettaglio){
            if ( dettaglio.getFirst()?.tipoAtto?.intValue() == tipoAttoEnum?.valore) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.getFirst().id])
            } else {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_apertura_record), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
