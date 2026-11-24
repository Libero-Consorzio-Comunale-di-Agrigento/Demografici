package restrict.statocivile.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAggiuntiva
import it.finmatica.de4gsdzk.statocivile.CivFormulaAggiuntivaService
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoFormulaAggiuntiva
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel
import restrict.statocivile.TraitTemplateListaStringhe

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FormulaAggiuntivaDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitTemplateListaStringhe {

    CivFormulaAggiuntiva dettaglio

    ETipoOperazione tipoOperazione

    @WireVariable
    private CivFormulaAggiuntivaService civFormulaAggiuntivaService

    @WireVariable
    private GsdService gsdService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Formula")]

        eList.addAll(CivFormulaAggiuntiva.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        // Aggiungo etichette tipo formula aggiuntiva
        eList.addAll(Arrays.asList(ETipoFormulaAggiuntiva.values())*.etichettaDesc)

        doInitEtichette(eList)

        List<String> lVar = gsdService.listVariabili(CivFormulaAggiuntiva.class, tipoAttoEnum.valore)
        setListaStringhe(lVar, getEtichetta(Etichette.getEtichetta("Variabili_Cerca")), 6)

        msgTitle = getEtichetta(Etichette.getEtichetta("Formula_CIA"))

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoEnum: tipoAttoEnum])
        }

        formLabel = (getEtichetta(Etichette.getEtichetta("Formula")) + " - " + getEtichettaEnum(dettaglio.tipoFormula)).toUpperCase()
    }

    void caricaDettaglio(def id) {
        dettaglio = civFormulaAggiuntivaService.get(id)

        refreshUi()
    }


    void creaDettaglio(Map params) {
        log.info ("not implemented" + ". Parametri passati: " + params?.size())
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivFormulaAggiuntiva c = civFormulaAggiuntivaService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }
}
