package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazioneService
import it.finmatica.de4gsdzk.statocivile.CivNotaFormula
import it.finmatica.de4gsdzk.statocivile.CivTestoFormula
import it.finmatica.de4gsdzk.utils.ETipoAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.statocivile.TraitTemplateListaStringhe

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FormulaComposizioneDettaglioViewModel extends AbstractDettaglioViewModel
                        implements TraitTemplateListaStringhe {

    CivFormulaAnnotazione dettaglio

    List<ETipoAnnotazione> listaTipoAnnotazione

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    ETipoOperazione tipoOperazione

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @WireVariable
    private GsdService gsdService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Funzione_non_abilitata"), Etichette.getEtichetta("Formula_Composizione")]
        eList.addAll(etichetteDettaglioDefault)

        eList.addAll(CivTestoFormula.etichetteDomain)
        eList.addAll(CivFormulaAnnotazione.etichetteDomain)
        eList.addAll(CivNotaFormula.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        // Aggiungo etichette tipo atto
        eList += ETipoAtto.values()*.getEtichettaDesc() as Map

        // Aggiungo etichette tipo annotazione
        listaTipoAnnotazione = [ETipoAnnotazione.A, ETipoAnnotazione.W]
        eList += listaTipoAnnotazione*.getEtichettaDesc() as Map

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Formula_Composizione"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio(tipoAtto:tipoAttoEnum.valore, testo: new CivTestoFormula())
        }

        caricaVariabili()

    }

    void caricaDettaglio(def id) {
        dettaglio = civFormulaAnnotazioneService.getWithTesto(id)
        tipoOperazione = ETipoOperazione.UPD
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new CivFormulaAnnotazione(params)
        dettaglio.testo.formula = dettaglio //x One2One
        tipoOperazione = ETipoOperazione.INS
    }

    private void caricaVariabili() {
        if (dettaglio){
            setListaStringhe(gsdService.listVariabili(CivTestoFormula.class, dettaglio.tipoAtto), getEtichetta(Etichette.getEtichetta("Variabili_Cerca")))
        } else {
            setListaStringhe([], getEtichetta(Etichette.getEtichetta("Variabili_Cerca")))
        }
    }

    @Command void onSalvaRecord() {
        if (saveRecordEnabled && dettaglio && userModifyEnabled) {
            salvaFormula()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void salvaFormula(){
        if (dettaglio){
            CivFormulaAnnotazione cfa = civFormulaAnnotazioneService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(cfa.id)
        }
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }


}
