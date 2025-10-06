package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivRichiamoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.statocivile.CivRichiamoFormulaService.FormulaUsataException
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarRichiamoAttributes
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.statocivile.TraitTemplateListaStringhe

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RichiamoFormulaDettaglioViewModel extends AbstractDettaglioViewModel implements TraitTemplateListaStringhe {

    CivRichiamoFormula dettaglio
    CivRichiamoComposizione richiamoComposizione

    ETipoOperazione tipoOperazione

    List<ETipoAnnotazione> listaTipoAnnotazione

    ETipoAtto tipoAttoEnum

    boolean testoEditabile

    String notaTesto

    @WireVariable
    private CivRichiamoFormulaService civRichiamoFormulaService

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("richiamoComposizione") CivRichiamoComposizione richiamoComposizione){
        self = w

        this.richiamoComposizione = richiamoComposizione

        List<Map<String, String>> eList = [Etichette.Formula_Composizione, Etichette.Testo, Etichette.Variabili_Cerca, Etichette.Formula_Associata]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Errore_Inserimento_Formula_Duplicata])
        eList.addAll(etichetteDettaglioDefault)
        eList.addAll(CivRichiamoBaseDomain.etichetteDomain)
        eList.addAll(CivRichiamoFormula.etichetteDomain)
        eList.addAll(CivFormulaAnnotazione.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarRichiamoAttributes.etichetteCbRichiamoDettaglioDesc)

        // Aggiungo etichette tipo atto
        eList += ETipoAtto.values()*.getEtichettaDesc() as Map

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        listaTipoAnnotazione = [ETipoAnnotazione.A, ETipoAnnotazione.W]

        msgTitle = getEtichetta(Etichette.Formula_Composizione)

        formLabel = msgTitle?.toUpperCase()

        resize()

        tipoAttoEnum = TipoAttoUtils.fromValoreDefault(richiamoComposizione.tipoAtto.intValue())

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio(
                    tipoAtto: richiamoComposizione.tipoAtto,
                    richiamo: richiamoComposizione.richiamo,
                    progressivo: richiamoComposizione.progressivo
            )
        }
        caricaNotaTesto()
        caricaVariabili()
    }

    void creaDettaglio(Map params) {
        dettaglio = new CivRichiamoFormula(params)
        tipoOperazione = ETipoOperazione.INS
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = civRichiamoFormulaService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshDettaglio()
    }

    void caricaNotaTesto() {
        notaTesto = null
        if (dettaglio.formula) {
            try {
                civRichiamoFormulaService.validaFormula(dettaglio)
            } catch(RecordDuplicatoRuntimeException rde) {
                notaTesto = getEtichetta((rde.getEtichetta()?:EtichetteMessaggi.Errore_Inserimento_Formula_Duplicata))
            } catch(De4gsdzkRuntimeException e) {
                notaTesto = e.getMessage()
            }
        }
        BindUtils.postNotifyChange(null, null, this, "notaTesto")
    }

    // Restituisce la nota testo (senza l'ultima frase se sono presenti \n)
    String getNotaTesto() {
        int cr = notaTesto ? notaTesto.lastIndexOf('\n') : 0
        return cr>0 ? notaTesto.substring(0, cr) : notaTesto
    }

    @Command void onSelectFormulaRichiamo(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CivFormulaAnnotazione) {
            dettaglio.formula =  civFormulaAnnotazioneService.getWithTesto(event.getData().id)
        } else {
            dettaglio.formula = null
        }
        caricaNotaTesto()
        caricaVariabili()
        refreshDettaglio()
    }

    @Command void onCancellaFormulaRichiamo() {
        onSelectFormulaRichiamo(null)
    }


    private void caricaVariabili() {
        if (dettaglio.formula){
            setListaStringhe(statoCivileService.listVariabili(CivTestoFormula.class, dettaglio.tipoAtto), getEtichetta(Etichette.Variabili_Cerca))
        } else {
            setListaStringhe([], getEtichetta(Etichette.Variabili_Cerca))
        }
    }

    /**
     * Salva il record catturando eventuali errori di validazione
     * @param forzaSave forza il salvataggio nel caso la formula sia usata da un altro richiamo
     */
    private void salvaRecord(boolean forzaSave=false) {
        try {
            CivRichiamoFormula c = civRichiamoFormulaService.save(dettaglio, forzaSave)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        } catch(FormulaUsataException fue) {
            log.info(fue.getMessage())
            Messagebox.show(fue.getMessage(), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK == e.getName()) {
                                salvaRecord(true)
                            }
                        }
                    }
            )
        }
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            salvaRecord()
        }
    }

    @Command void onBloccaSbloccaTesto() {
        testoEditabile = !testoEditabile
        refreshUi()
    }

}
