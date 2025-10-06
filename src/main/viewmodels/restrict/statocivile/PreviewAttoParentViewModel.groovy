package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.IEntitaAnsc
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarTestoAttributes
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractResizedViewModel

import javax.persistence.criteria.JoinType

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class PreviewAttoParentViewModel extends AbstractResizedViewModel{

    Window   self

    String msgTitle = ""

    Map<String, String> etichette = [:]

    CivAttoBaseDomain atto
    CivDatiProvenienzaAtto datiProvenienza
    CivTestoLibero dettaglio
    List<CivFormulaTestoLibero> formuleMargine
    List<CivAnnotazioneAtto> formuleAnnotazioni
    CivOcchiello occhiello
    CivMargine margine

    Map<String, CivFormulaTestoLibero> mapFormule = [:]

    Boolean testoEditable = Boolean.FALSE
    Boolean margineEditable = Boolean.FALSE

    int numRighe = 0
    int numColonne = 0
    boolean blocca = true

    Boolean margineOn = Boolean.TRUE
    Boolean anscOn = Boolean.FALSE
    Boolean anscIntestazioneOn = Boolean.FALSE

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private CivTipoAttoService civTipoAttoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivTestoLiberoService civTestoLiberoService

    @WireVariable
    private CivFormulaTestoLiberoService civFormulaTestoLiberoService

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private ArcParametroService arcParametroService

    protected void doInit(Window w) {
        self = w

        List<Map> eList = [Etichette.Provvisorio, Etichette.Chiudi_atto, Etichette.Testo, Etichette.Numero_comunale]
        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)
        eList.addAll(ControlBarTestoAttributes.etichetteCbTestoDesc)

        // Aggiungo etichette dell' Occhiello
        eList.addAll(CivOcchiello.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Warn_Dati_Occhiello, EtichetteMessaggi.Errore_modello_testo_non_trovato,
                      EtichetteMessaggi.Errore_apertura_record, EtichetteMessaggi.Errore_generazione_testo,
                      EtichetteMessaggi.Errore_report_vuoto, EtichetteMessaggi.Errore_report_troppo_lungo,
                      EtichetteMessaggi.Errore_stampa_provvisorio, EtichetteMessaggi.Ask_Modifiche_In_Sospeso])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(etichette, Etichette.Testo)
    }

    void caricaAtto(ETipoAtto tipoAttoEnum, Long pkAtto) {
        Map params = [fetch:[[campo:'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT]]]
        if (tipoAttoEnum == ETipoAtto.MAT){
            // per la formula del libretto internazionale di famiglia devo tirare su anche la nazionalità
            params.fetch.add([campo:'nazionalita1', tipo: JoinType.LEFT])
            params.fetch.add([campo:'nazionalita2', tipo: JoinType.LEFT])
        }
        atto = civAttoService.getAtto(tipoAttoEnum, pkAtto, params)

        if (atto == null){
            String errorMsg = getEtichetta(etichette, EtichetteMessaggi.Errore_apertura_record)
            Messagebox.show(errorMsg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            onChiudi()
            return
        }

        CivTipoAtto c = ((atto?.tipoAttoDomain?.id != null)?civTipoAttoService.get(atto.tipoAttoDomain.id):civTipoAttoService.listAllByTipoAttoAndParteAndSerieAndNatura(atto.tipoAtto, atto.parte, atto.serie, atto.natura)?.get(0))
        numRighe = (c?.numeroRighe?.intValue()?:0)
        numColonne = (c?.numeroColonne?.intValue()?:0)
        blocca = ((c?.dimensioniFisse != null)?c.dimensioniFisse:Boolean.TRUE)

        Boolean anscInt = Boolean.FALSE
        List<ArcParametro> lParams = arcParametroService.listAllByIdIn([ArcParametro.ANSC,
                                                                        ArcParametro.ANSC_INT,
                                                                        ArcParametro.ATTI_MAR])
        for (ArcParametro p: lParams){
            switch(p.id) {
                case ArcParametro.ANSC:
                    anscOn = (p?.valore?.trim()?.toUpperCase() == ETipoSN.S.name())
                    break
                case ArcParametro.ANSC_INT:
                    anscInt = ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.S.name()) != ETipoSN.N.name())
                    break
                case ArcParametro.ATTI_MAR:
                    if (atto.hasMargine()) {
                        margineOn = ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.S.name()) != ETipoSN.N.name())
                    }
                    break
            }
        }
        anscIntestazioneOn = (anscOn && anscInt)
    }

    abstract void caricaTestoAtto(Boolean rigeneraTesto)

    List<String> getChiaviMargine(){
        List<String> chiavi = []
        switch (atto.getTipoAttoEnum()) {
            case ETipoAtto.NAS:
                if (anscOn && ((IEntitaAnsc)atto).getNumeroUnico() != null) {
                    // refs #73234
                    chiavi = []
                } else {
                    chiavi = [FormulaUtils.FORMULA_MARGINE_TR1, FormulaUtils.FORMULA_MARGINE_SENTENZA]
                }
                break
            case ETipoAtto.MAT:
                CivMatrimonio m = atto
                if (m.divorzio){
                    chiavi = []
                } else {
                    if (anscOn && ((IEntitaAnsc)atto).getNumeroUnico() != null) {
                        chiavi = [FormulaUtils.FORMULA_MARGINE_CONVENZIONI, FormulaUtils.FORMULA_MARGINE_LIBRETTO]
                    } else {
                        chiavi = [FormulaUtils.FORMULA_MARGINE_MINISTRO, FormulaUtils.FORMULA_MARGINE_TR1, FormulaUtils.FORMULA_MARGINE_TR2,
                                  FormulaUtils.FORMULA_MARGINE_CONVENZIONI, FormulaUtils.FORMULA_MARGINE_LIBRETTO]
                    }
                }
                break
            case ETipoAtto.MOR:
                if (anscOn && ((IEntitaAnsc)atto).getNumeroUnico() != null) {
                    chiavi = [FormulaUtils.FORMULA_MARGINE_NASCITA]
                } else {
                    chiavi = [FormulaUtils.FORMULA_MARGINE_TR1, FormulaUtils.FORMULA_MARGINE_NASCITA]
                }
                break
            case ETipoAtto.UCI:
                CivUnioneCivile m = atto
                if (m.divorzio){
                    chiavi = []
                } else {
                    chiavi = [FormulaUtils.FORMULA_MARGINE_COGNOME_1, FormulaUtils.FORMULA_MARGINE_COGNOME_2, FormulaUtils.FORMULA_MARGINE_CONVENZIONI]
                }
                break
        }
        return chiavi
    }

    void generaFormuleMargine(Boolean rigeneraTesto){
        List<String> chiavi = getChiaviMargine()
        if (chiavi.size() > 0){
            List<CivFormulaTestoLibero> formuleMargineLista = civFormulaTestoLiberoService.listAllByUKAttoAndRichiamo(atto.idAtto, FormulaUtils.getRichiamoMargine())
            for (String chiave : chiavi){
                mapFormule[chiave] = FormulaUtils.getFormula(formuleMargineLista, chiave)
                if (checkFormulaMargineInUso(chiave)){
                    if ( (mapFormule[chiave] == null) || rigeneraTesto ){
                        searchFormulaMargineDefault(chiave)
                    }
                } else {
                    if (mapFormule[chiave]?.id != null) {
                        civFormulaTestoLiberoService.delete(mapFormule[chiave])
                    }
                }
            }
        }
    }

    // Implemento il controllo per la sola formula del libretto internazionale di famiglia, ma apro la strada anche
    // al check di altre formule a margine; per la formula del libretto di famiglia, 'Apri' e 'Rigenera' della preview
    // si comportano allo stesso modo
    private boolean checkFormulaMargineInUso(String chiave){
        switch (atto.getTipoAttoEnum()) {
            case ETipoAtto.MAT:
                if (chiave == FormulaUtils.FORMULA_MARGINE_LIBRETTO) {
                    return margine.stampaFormulaLibretto
                }
                break
        }
        return true
    }

    private void searchFormulaMargineDefault(String chiave){
        log.info("Tento recupero ${chiave.toUpperCase()} per l'atto ${atto.getTipoAttoEnum().name()} con id ${atto.id}")
        Map params = [parte: atto.parte, serie: atto.serie, natura: atto.natura, flagDefault:Boolean.TRUE,
                      categoria: atto.tipoAttoDomain?.categoriaDomain?.codice]
        List<Map<String, Object>> formule = []
        ArcComune c = statoCivileService.getComuneCliente()
        switch (atto.getTipoAttoEnum()) {
            case ETipoAtto.NAS:
                if (FormulaUtils.addFormulaNascita(chiave, ETipoOperazione.UPD, atto, datiProvenienza, c)){
                    switch (chiave) {
                        case FormulaUtils.FORMULA_MARGINE_TR1:
                            params.put("progressivo", FormulaUtils.getProgressivoMargineTr1())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                        case FormulaUtils.FORMULA_MARGINE_SENTENZA:
                            params.put("progressivo", FormulaUtils.getProgressivoMargineSentenza())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                    }
                    formule = statoCivileService.listFormuleNascita(FormulaUtils.getRichiamoMargine(), params)
                }
                break
            case ETipoAtto.MAT:
                if (FormulaUtils.addFormulaMatrimonio(chiave, ETipoOperazione.UPD, atto, margine, c)){
                    switch (chiave) {
                        case FormulaUtils.FORMULA_MARGINE_MINISTRO:
                            params.put("progressivo", FormulaUtils.getProgressivoMargineMinistro())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                        case FormulaUtils.FORMULA_MARGINE_TR1:
                            params.put("progressivo", FormulaUtils.getProgressivoMargineTr1())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                        case FormulaUtils.FORMULA_MARGINE_TR2:
                            params.put("progressivo", FormulaUtils.getProgressivoMargineTr2())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                        case FormulaUtils.FORMULA_MARGINE_CONVENZIONI:
                            params.put("progressivo", FormulaUtils.getProgressivoMargineConvenzioni())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                        case FormulaUtils.FORMULA_MARGINE_LIBRETTO:
                            params.put("progressivo", FormulaUtils.getProgressivoMargineLibretto())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                    }
                    formule = statoCivileService.listFormuleMatrimonio(FormulaUtils.getRichiamoMargine(), params)
                }
                break
            case ETipoAtto.MOR:
                if (FormulaUtils.addFormulaDecesso(chiave, ETipoOperazione.UPD, atto, c)){
                    switch (chiave) {
                        case FormulaUtils.FORMULA_MARGINE_TR1:
                            params.put("progressivo", FormulaUtils.getProgressivoMargineTr1())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                        case FormulaUtils.FORMULA_MARGINE_NASCITA:
                            params.put("progressivo", FormulaUtils.getProgressivoMargineNascita())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                    }
                    formule = statoCivileService.listFormuleDecesso(FormulaUtils.getRichiamoMargine(), params)
                }
                break
            case ETipoAtto.UCI:
                if (FormulaUtils.addFormulaUnioneCivile(chiave, ETipoOperazione.UPD, atto, null)){
                    switch (chiave) {
                        case FormulaUtils.FORMULA_MARGINE_CONVENZIONI:
                            params.put("progressivo", FormulaUtils.getProgressivoMargineConvenzioni())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                        case FormulaUtils.FORMULA_MARGINE_COGNOME_1:
                            if (atto.cambioCognome1){
                                params.put("sceltaCognome1", ETipoSiNo.SI.name() )
                            }
                            params.put("progressivo", FormulaUtils.getProgressivoMargineCognome1())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                        case FormulaUtils.FORMULA_MARGINE_COGNOME_2:
                            if (atto.cambioCognome2){
                                params.put("sceltaCognome2", ETipoSiNo.SI.name() )
                            }
                            params.put("progressivo", FormulaUtils.getProgressivoMargineCognome2())
                            params.put("searchEqual", Boolean.TRUE)
                            break
                    }
                    formule = statoCivileService.listFormuleUnioneCivile(FormulaUtils.getRichiamoMargine(), params)
                }
                break
        }
        if (formule?.size() == 1){
            CivFormulaTestoLibero f = null
            if (mapFormule[chiave]?.id != null){
                f = mapFormule[chiave]
            } else {
                f = new CivFormulaTestoLibero()
            }
            statoCivileService.aggiornaFormulaFrammento(formule, atto, f)
            DomainUtils.initFromAtto(f, atto)
            mapFormule[chiave] = civFormulaTestoLiberoService.save(f, atto.getTipoAttoEnum())
        }
    }

    @Command void onBloccaSbloccaTesto() {
        if (testoEditable){
            onSalvaRecord()
            testoEditable = !testoEditable
        } else {
            testoEditable = !testoEditable
        }
        refreshUi()
    }

    @Command void onBloccaSbloccaMargine() {
        if (margineEditable){
            onSalvaRecord()
            margineEditable = !margineEditable
        } else {
            margineEditable = !margineEditable
        }
        refreshUi()
    }

    /*
    //Consentire la cancellazione delle formule del margine?
    @Command void onEliminaFormulaMargine(@BindingParam("formulaMargine") CivFormulaTestoLibero ftli){
        if (ftli?.id){
            Messagebox.show("Cancellare la formula selezionata?", msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener(){
                    public void onEvent(Event e){
                        if (Messagebox.ON_OK.equals(e.getName())){
                            civFormulaTestoLiberoService.delete(ftli)
                            for (CivFormulaTestoLibero f: formuleMargine){
                                if (f.id.equals(ftli.id)){
                                    formuleMargine.remove(f)
                                    break
                                }
                            }
                            refreshUi()
                        }
                    }
                }
            )
        }
    }
    */

    @Command void onSalvaRecord() {
        if (dettaglio) {
            civTestoLiberoService.save(dettaglio, atto.getTipoAttoEnum(), occhiello, formuleMargine)
            caricaTestoAtto(Boolean.FALSE)
        }
    }

    @Command onChiudi () {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Command void onBackFromRecord() {
        if (testoEditable || margineEditable){
            Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Ask_Modifiche_In_Sospeso), getEtichetta(etichette, Etichette.Chiusura), Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener(){
                    void onEvent(Event e){
                        if (Messagebox.ON_YES.equals(e.getName())){
                            Events.postEvent(CustomEvents.ON_BACK_FROM_RECORD, self, [:])
                            onChiudi()
                        }
                    }
                }
            )
        } else {
            Events.postEvent(CustomEvents.ON_BACK_FROM_RECORD, self, [:])
            onChiudi()
        }
    }

    void refreshUi(){
        BindUtils.postNotifyChange(null, null, this, "*")
    }

}
