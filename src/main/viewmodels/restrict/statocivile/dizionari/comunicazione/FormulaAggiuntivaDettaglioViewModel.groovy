package restrict.statocivile.dizionari.comunicazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivFormulaAggiuntiva
import it.finmatica.de4gsdzk.statocivile.CivFormulaAggiuntivaService
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.*
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
    private StatoCivileService statoCivileService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Formula]

        eList.addAll(CivFormulaAggiuntiva.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        // Aggiungo etichette tipo formula aggiuntiva
        eList.addAll(Arrays.asList(ETipoFormulaAggiuntiva.values())*.etichettaDesc)

        doInitEtichette(eList)

        List<String> lVar = statoCivileService.listVariabili(CivFormulaAggiuntiva.class, tipoAttoEnum.valore)
        setListaStringhe(lVar, getEtichetta(Etichette.Variabili_Cerca), 6)

        msgTitle = getEtichetta(Etichette.Formula_CIA)

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoEnum: tipoAttoEnum])
        }

        formLabel = (getEtichetta(Etichette.Formula) + " - " + getEtichettaEnum(dettaglio.tipoFormula)).toUpperCase()
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
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }
}
