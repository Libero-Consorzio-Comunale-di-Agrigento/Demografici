package restrict.statocivile.dizionari.annotazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazioneService
import it.finmatica.de4gsdzk.statocivile.CivTestoFormula
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import it.finmatica.de4gsdzk.utils.ETipoAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FormulaAnnotazioneDettaglioInfoViewModel extends AbstractDettaglioViewModel{

    CivFormulaAnnotazione dettaglio

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id){
        self = w

        List<Map<String, String>> eList = [Etichette.Formula_Annotazione, Etichette.Annotazioni]
        eList.addAll(etichetteDettaglioDefault)

        eList.addAll(CivTestoFormula.etichetteDomain)
        eList.addAll(CivFormulaAnnotazione.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        // Aggiungo etichette tipo annotazione
        eList.addAll([ETipoAnnotazione.M, ETipoAnnotazione.C]*.etichettaDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.Formula_Annotazione)

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null){
            caricaDettaglio(id)
        }
    }

    void caricaDettaglio(def id) {
        dettaglio = civFormulaAnnotazioneService.getWithTesto(id)
        refreshUi()
    }

    void creaDettaglio(Map params){
        log.info ("not implemented - not necessary" + ". Parametri passati: " + params?.size())
    }

}
