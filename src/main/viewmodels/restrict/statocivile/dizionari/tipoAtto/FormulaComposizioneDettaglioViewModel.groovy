package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
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
    private StatoCivileService statoCivileService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Funzione_non_abilitata, Etichette.Formula_Composizione]
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

        msgTitle = getEtichetta(Etichette.Formula_Composizione)

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
            setListaStringhe(statoCivileService.listVariabili(CivTestoFormula.class, dettaglio.tipoAtto), getEtichetta(Etichette.Variabili_Cerca))
        } else {
            setListaStringhe([], getEtichetta(Etichette.Variabili_Cerca))
        }
    }

    @Command void onSalvaRecord() {
        if (saveRecordEnabled && dettaglio && userModifyEnabled) {
            salvaFormula()
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void salvaFormula(){
        if (dettaglio){
            CivFormulaAnnotazione cfa = civFormulaAnnotazioneService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(cfa.id)
        }
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }


}
