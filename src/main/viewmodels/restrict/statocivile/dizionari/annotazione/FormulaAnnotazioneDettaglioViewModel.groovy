package restrict.statocivile.dizionari.annotazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import it.finmatica.de4gsdzk.zkutils.CustomPopup
import org.springframework.data.domain.Sort
import org.zkoss.bind.BindContext
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FormulaAnnotazioneDettaglioViewModel extends AbstractDettaglioViewModel{

    CivFormulaAnnotazione dettaglio

    final List<ETipoAnnotazione> listaTipoAnnotazione = [ETipoAnnotazione.M, ETipoAnnotazione.C]

    List<FrammentoFormulaAnnotazione> listaFrammentiFormula = []

    final List<EGenereAnnotazione> listaGenereAnnotazione = [null] + [EGenereAnnotazione.RET, EGenereAnnotazione.EMA]

    Boolean anscOn = Boolean.FALSE

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    CustomPopup ppNota
    CustomPopup ppAnteprima

    ETipoOperazione tipoOperazione

    boolean annotazioniAutomaticheEnabled = false

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @WireVariable
    private CivNotaFormulaService civNotaFormulaService

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Chiudi"), Etichette.getEtichetta("Eventuale_Testo_fisso"), Etichette.getEtichetta("Eventuale_Testo_fisso_finale"),
                                           Etichette.getEtichetta("Funzione_non_abilitata"), Etichette.getEtichetta("Formula_Annotazione"), Etichette.getEtichetta("Annotazioni"), Etichette.getEtichetta("anteprima_testo_tooltip")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Ask_Aggiornamento_Annotazione"), Etichette.getEtichetta("Errore_creazione_frammenti_formula")])
        eList.addAll(etichetteDettaglioDefault)

        eList.addAll(CivTestoFormula.etichetteDomain)
        eList.addAll(CivFormulaAnnotazione.etichetteDomain)
        eList.addAll(CivNotaFormula.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        // Aggiungo etichette tipo annotazione
        eList.addAll(Arrays.asList(ETipoAnnotazione.values())*.etichettaDesc)

        // Aggiungo etichette sul genere delle Annotazioni
        eList.addAll(Arrays.asList(EGenereAnnotazione.values())*.etichettaDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Formula_Annotazione"))

        formLabel = msgTitle?.toUpperCase()

        annotazioniAutomaticheEnabled = false //(gsdService.getValoreParametro(ArcParametro.TANN_AUTO) == ETipoSN.S.name() )
        anscOn = arcParametroService.isIntegrazioneAnscAttiva()

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoEnum:tipoAttoEnum])
        }
    }

    @AfterCompose(superclass = true)
    void afterCompose() {
        if (!ppNota) {
            List<Component> components = Selectors.find(self, '#ppNota')
            ppNota = components ? components.first() : null
        }
        if (!ppAnteprima){
            List<Component> components = Selectors.find(self, '#ppAnteprima')
            ppAnteprima = components ? components.first() : null
        }
    }

    void caricaDettaglio(def id) {
        tipoOperazione = ETipoOperazione.UPD
        listaFrammentiFormula = []
        dettaglio = civFormulaAnnotazioneService.getWithTesto(id)
        if (dettaglio?.id){
            List<CivNotaFormula> lnf = civNotaFormulaService.listAllByFormula(dettaglio.id, new Sort(SortUtils.variabileDesc))
            String testoDaParsare = (dettaglio.testo?.testoA4?:"")
            if ((testoDaParsare ?: "") != "") {
                int i = testoDaParsare.indexOf(TestoUtils.cancelletto)
                while (i>=0){
                    String testofisso = testoDaParsare.substring(0, i)
                    testoDaParsare = testoDaParsare.substring(i+1)
                    String numeroVar = recuperaVariabile(testoDaParsare)
                    if ((numeroVar ?: "") != "") {
                        CivNotaFormula nf = lnf.find { it.variabile.compareTo(new Integer(numeroVar)) == 0 }
                        FrammentoFormulaAnnotazione fr = new FrammentoFormulaAnnotazione(testofisso, nf)
                        listaFrammentiFormula.add(fr)
                        testoDaParsare = testoDaParsare.substring(numeroVar.length())
                    } else {
                        listaFrammentiFormula.add(new FrammentoFormulaAnnotazione(testofisso))
                    }
                    i = testoDaParsare.indexOf(TestoUtils.cancelletto)
                }
                if (testoDaParsare.length() > 0){
                    listaFrammentiFormula.add(new FrammentoFormulaAnnotazione(testoDaParsare))
                }
            } else {
                listaFrammentiFormula.add(new FrammentoFormulaAnnotazione(""))
            }
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        CivTestoFormula testo = new CivTestoFormula()
        dettaglio = new CivFormulaAnnotazione(tipoAtto: new Integer(params.tipoAttoEnum.valore), nuovoOrdinamento: Boolean.TRUE, testo: testo)
        testo.formula = dettaglio
        listaFrammentiFormula = new ArrayList<FrammentoFormulaAnnotazione>()
        listaFrammentiFormula.add(new FrammentoFormulaAnnotazione(""))
        tipoOperazione = ETipoOperazione.INS
    }

    @Command void onSalvaRecord() {
        if (saveRecordEnabled && dettaglio && userModifyEnabled) {
            Boolean inUso = civAnnotazioneAttoService.checkAnnotazioneInUso(dettaglio.id)
            if (inUso){
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Aggiornamento_Annotazione")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                        new org.zkoss.zk.ui.event.EventListener(){
                            void onEvent(Event e){
                                if (Messagebox.ON_OK.equals(e.getName())){
                                    salvaFormula()
                                }
                            }
                        }
                )
            } else {
                salvaFormula()
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void salvaFormula(){
        if (dettaglio){
            Map m = elaboraTestoENote()
            List<CivNotaFormula> lnf = m.note
            dettaglio.testo?.testoA4 = m.testo

            CivFormulaAnnotazione cfa = civFormulaAnnotazioneService.save(tipoOperazione, dettaglio, lnf)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(cfa.id)
        }
    }

    private String recuperaVariabile(String t){
        String n = ""
        if ((t?:"").length() > 0){
            String c = t.substring(0,1)
            if (c.isInteger()){
                n = c + recuperaVariabile(t.substring(1))
            }
        }
        return n
    }

    private String anteponiSpazioSeNecessario(String tPre, String tDaConcatenare) {
        if (tDaConcatenare){
            if ( (tPre?:"").endsWith(TestoUtils.spazio) || tDaConcatenare.startsWith(TestoUtils.spazio) ||
                   TestoUtils.isVuoto(tPre) || TestoUtils.isVuoto(tDaConcatenare) ){
                return tDaConcatenare
            }
            return TestoUtils.spazio + tDaConcatenare
        }
        return ""
    }

    private Map elaboraTestoENote() {
        List<CivNotaFormula> lnf = new ArrayList<CivNotaFormula>()
        String tConVar = ""
        for (FrammentoFormulaAnnotazione fr : listaFrammentiFormula) {
            tConVar += anteponiSpazioSeNecessario(tConVar, fr.testoFisso)
            CivNotaFormula n = fr.notaFormula
            if (n) {
                lnf.add(n)
                tConVar += anteponiSpazioSeNecessario(tConVar, (TestoUtils.cancelletto + n.variabile.toString()))
            }
        }
        return [testo: tConVar, note: lnf]
    }

    @Command void onShowAnteprima(@ContextParam(ContextType.BIND_CONTEXT) BindContext ctx) {
        Map m = elaboraTestoENote()
        ppAnteprima.testo = civFormulaAnnotazioneService.getTestoAnnotazioneDaDecodificare(m.testo, m.note)
        ppAnteprima.open(ctx.getComponent(), 'before_start')
        BindUtils.postNotifyChange(null, null, this, "ppAnteprima")
    }

    @Command void onCloseAnteprima() {
        ppAnteprima.close()
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

    @Command void onAddNotaFormula() {
        int maxVarValue = 0
        for (FrammentoFormulaAnnotazione fr: listaFrammentiFormula){
            if (fr.notaFormula?.variabile?.intValue() > maxVarValue){
                maxVarValue = fr.notaFormula.variabile.intValue()
            }
        }
        int newVarValue = maxVarValue + 1

        int newVarPosition = getLastNotaFormulaPosition() + 1
        if (newVarPosition >= CivNotaFormula.MAX_NOTA_FORMULA_ELEMENTS){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_creazione_frammenti_formula")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            FrammentoFormulaAnnotazione newFr = new FrammentoFormulaAnnotazione("", new CivNotaFormula(variabile: new Integer(newVarValue), formula : dettaglio))
            listaFrammentiFormula.add(newVarPosition, newFr)
            BindUtils.postNotifyChange(null, null, this, "listaFrammentiFormula")
        }
    }

    int getLastNotaFormulaPosition(){
        int lastVarPosition = -1
        for (int i=listaFrammentiFormula.size()-1; i>=0; i--){
            FrammentoFormulaAnnotazione fr = listaFrammentiFormula[i]
            if (fr.notaFormula?.variabile != null){
                if (i > lastVarPosition){
                    lastVarPosition = i
                    break
                }
            }
        }
        return lastVarPosition
    }

    @Command void onRemoveNotaFormula() {
        int lastVarPosition = getLastNotaFormulaPosition()
        if (lastVarPosition >= 0){
            listaFrammentiFormula.remove(lastVarPosition)
            BindUtils.postNotifyChange(null, null, this, "listaFrammentiFormula")
        }
    }

    @Command void onShowHelp(@ContextParam(ContextType.BIND_CONTEXT) BindContext ctx, @BindingParam("notaFormula") CivNotaFormula notaFormula) {
        ppNota.notaFormula = notaFormula
        ppNota.open(ctx.getComponent(), 'end_before')
        BindUtils.postNotifyChange(null, null, this, "ppNota")
    }

    @Command void onSelectCampoAnnotazione(@ContextParam(ContextType.TRIGGER_EVENT) Event event, @BindingParam("ppNota") CustomPopup ppNota, @BindingParam("campo") String campo) {
        String var = null
        if (event?.target?.selectedItem instanceof String) {
            var = event.target.selectedItem
        }
        ppNota.notaFormula."$campo" = var?.toUpperCase()
        BindUtils.postNotifyChange(null, null, this, "ppNota")
    }

    @Command void onCancellaCampoAnnotazione(@BindingParam("ppNota") CustomPopup ppNota, @BindingParam("campo") String campo) {
        onSelectCampoAnnotazione(null, ppNota, campo)
    }

    @Command void onCloseHelp() {
        ppNota.close()
    }

}
