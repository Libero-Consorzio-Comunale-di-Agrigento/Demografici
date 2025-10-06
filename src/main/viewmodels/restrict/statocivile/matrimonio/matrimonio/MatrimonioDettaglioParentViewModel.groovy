package restrict.statocivile.matrimonio.matrimonio

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.IEstremiAttoMatrimonioDomain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggettiDomain
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.AttoSoggettiDettaglioParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class MatrimonioDettaglioParentViewModel extends AttoSoggettiDettaglioParentViewModel{

    CivMatrimonio dettaglio

    List<Map> listaBoolean
    List<Map> listaTipoLuogoCelebrazione
    List<Map> listaImpossibilitato = []
    final List<ETipoMargineLaterale> listaMargineLaterale = Arrays.asList(ETipoMargineLaterale.values())
    List<String> listaRito = []
    List<Map<String, ?>> listaConvenzioni = []
    List<EDocumentoMatrimonio> listaDocumentiPresentati = []
    // Da gestire solo per gli atti in inserimento e non per i consolidati/pregressi
    List<CivFormulaAnnotazione> listaAnnotazioniNascita = []

    final List<ETipoDifettoEta> listaDifettoEta = [null] + Arrays.asList(ETipoDifettoEta.values())
    final List<ETipoImpedimentoParentelaMatrimonio> listaImpedimentoParentelaMatrimonio = [null] + Arrays.asList(ETipoImpedimentoParentelaMatrimonio.values())
    final List<ETipoDocumentoFineOpposizione> listaTipoDocumentoFineOpposizione = [null] + Arrays.asList(ETipoDocumentoFineOpposizione.values())
    final List<ETipoAssistenzaMinore> listaTipoAssistenzaMinore = [null] + Arrays.asList(ETipoAssistenzaMinore.values())

    List<Map> listaDichiarante = []
    List<Map> listaComparente = []
    List<Map> listaFirmatario = []

    Boolean comuneAffissione1Estero = Boolean.FALSE
    Boolean comuneAffissione2Estero = Boolean.FALSE

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivMatrimonioService civMatrimonioService

    void doInit(Window w, Long id, CivTipoAtto tipoAttoDomain) {
        self = w

        initMinuscole(ETipoAtto.MAT)

        List<Map> eList = []
        eList.addAll(CivMatrimonio.etichetteDomain)
        eList.addAll([Etichette.Comune_Atto, Etichette.Pubblicazioni, Etichette.Comune, Etichette.Data_Redazione_Atto_Originale, Etichette.Recupero_da_verbale_pubblicazione,
                      Etichette.Celebrante, Etichette.Rito, Etichette.Sacerdote, Etichette.Documenti_presentati, Etichette.Comuni_pubblicazione,
                      Etichette.Scelta_legge_da_applicare, Etichette.Scelta_regime_separazione, Etichette.Annotazione,
                      Etichette.Difetto_eta, Etichette.Impedimento_Par, Etichette.Impossibilitato, Etichette.Certificato_del,
                      Etichette.Nella_casa_comunale, Etichette.Fuori_della_casa_comunale,
                      Etichette.Opposizione, Etichette.Opposizione_nessuna, Etichette.Opposizione_rigetto, Etichette.Opposizione_estinzione,
                      Etichette.Impedimento_Eta_doc, Etichette.Impedimento_Par_doc, Etichette.Impedimento_Temp_doc])

        eList.addAll(CivDatiProvenienzaAtto.etichetteDomain)
        eList.addAll(CivMargine.etichetteDomain)
        eList.addAll(CivTestimoniAtto.etichetteDomain)

        // Aggiungo label frammenti specifici
        eList.addAll([Etichette.Dati_Matrimonio, Etichette.Sposi, Etichette.Documenti, Etichette.Richiesta, Etichette.Testimoni,
                      Etichette.Altri_Dati, Etichette.Impedimenti, Etichette.Riconoscimento_Figli, Etichette.Convenzioni_Patrimoniali,
                      Etichette.Articoli_Pubblicazioni])

        // Aggiungo titoli sezioni
        eList.addAll([Etichette.SEZIONE_INFORMAZIONI_ATTO, Etichette.SEZIONE_SPOSI, Etichette.SEZIONE_DATI_MATRIMONIO,
                      Etichette.SEZIONE_ATTO_ORIGINALE, Etichette.SEZIONE_TESTIMONI, Etichette.SEZIONE_COMPOSIZIONE,
                      Etichette.SEZIONE_REDAZIONE, Etichette.SEZIONE_ANNOTAZIONI_DA_ATTO])

        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Errore_formula_libretto_internazionale, EtichetteMessaggi.Errore_carattere_a_capo_non_ammesso])

        // Aggiungo etichette natura atto
        listaNatura = NaturaUtils.getValoriMatrimonio()
        eList.addAll(listaNatura*.etichettaDesc)

        // Aggiungo etichette sesso
        listaSesso = [null] + ESesso.values().toList()
        eList.addAll(ESesso.values()*.getEtichettaDesc())

        // Aggiungo etichette per FCC/PDV Impossibilitato
        eList.addAll(Arrays.asList(EImpossibilitato.values())*.etichettaDesc)

        // Aggiungo etichette margine laterale
        eList.addAll(Arrays.asList(ETipoMargineLaterale.values())*.etichettaDesc)

        // Aggiungo etichette documenti presentati
        listaDocumentiPresentati = Arrays.asList(EDocumentoMatrimonio.values())
        eList.addAll(listaDocumentiPresentati*.etichettaDesc)

        // Aggiungo etichette difetto d'età
        eList.addAll(ETipoDifettoEta.values()*.getEtichettaDesc())

        // Aggiungo etichette impedimento matrimonio
        eList.addAll(ETipoImpedimentoParentelaMatrimonio.values()*.getEtichettaDesc())

        // Aggiungo etichette fine opposizione
        eList.addAll(ETipoDocumentoFineOpposizione.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo asssitenza minore
        eList.addAll(ETipoAssistenzaMinore.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo dichiarante
        eList.addAll((Arrays.asList(ETipoDichiaranteMatrimonioDivorzio.values()))*.etichettaDesc)

        doInitAllAtti(eList)

        msgTitle = getEtichetta(Etichette.Atto_Matrimonio)
        tipoAttoLabel = getEtichettaEnum(ETipoAtto.MAT)

        listaImpossibilitato = [null] + [getDCFItem(EImpossibilitato.SO),
                                         getDCFItem(EImpossibilitato.SA),
                                         getDCFItem(EImpossibilitato.EN)]

        listaBoolean = [[label: getEtichettaEnum(ETipoSiNo.SI), value: Boolean.TRUE], [label:getEtichettaEnum(ETipoSiNo.NO), value: Boolean.FALSE]]

        listaTipoLuogoCelebrazione = [[label: getEtichetta(Etichette.Nella_casa_comunale), value: Boolean.TRUE], [label:getEtichetta(Etichette.Fuori_della_casa_comunale), value: Boolean.FALSE]]

        listaComparente = []
        listaFirmatario = []

        listaRito = statoCivileService.listRiti()

        listaConvenzioni = [[label: getEtichetta(Etichette.Scelta_regime_separazione), value: new Integer(1)],
                            [label: getEtichetta(Etichette.Scelta_legge_da_applicare), value: new Integer(2)]]

        resize()

        if (id){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoDomain:tipoAttoDomain])
        }

        caricaComuneAffissione1Estero()
        caricaComuneAffissione2Estero()
    }

    private caricaComuneAffissione1Estero() {
        if (statoCivileService.checkComuneEstero(margine.comuneAffissione1.codiceProvincia, margine.comuneAffissione1.codice)) {
            comuneAffissione1Estero = Boolean.TRUE
        } else {
            comuneAffissione1Estero = Boolean.FALSE
            margine.consolatoAffisione1 = null
        }
    }


    private caricaComuneAffissione2Estero() {
        if (statoCivileService.checkComuneEstero(margine.comuneAffissione2.codiceProvincia, margine.comuneAffissione2.codice)) {
            comuneAffissione2Estero = Boolean.TRUE
        } else {
            comuneAffissione2Estero = Boolean.FALSE
            margine.consolatoAffisione2 = null
        }
    }

    protected void caricaListaDichiarante(){
        // Dipende da parte e serie
        if (dettaglio.isSecondaA()){
            listaDichiarante = [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.MC),
                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSA)]
            // comparente e firmatario per le 2A non sono da esibire
        } else {
            listaDichiarante = [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSA)]
        }
    }

    List<String> getChiaviFormule(){
        return [FormulaUtils.FORMULA_TESTATA_TRASCRIZIONE, FormulaUtils.FORMULA_TESTATA, FormulaUtils.FORMULA_DATI_MATRIMONIO,
                FormulaUtils.FORMULA_SPOSI, FormulaUtils.FORMULA_RICHIESTA_FISSA, FormulaUtils.FORMULA_TESTIMONI,
                FormulaUtils.FORMULA_DOCUMENTI_FISSA, FormulaUtils.FORMULA_DOCUMENTI, FormulaUtils.FORMULA_MATRIMONIO_CONCORDATARIO,
                FormulaUtils.FORMULA_AMMISSIONE_OLTRE_IMPEDIMENTI, FormulaUtils.FORMULA_RICONOSCIMENTO_FIGLI,
                FormulaUtils.FORMULA_REGIME_PATRIMONIALE, FormulaUtils.FORMULA_PUBBLICAZIONI_FISSA, FormulaUtils.FORMULA_PUBBLICAZIONI,
                FormulaUtils.FORMULA_CHIUSURA, FormulaUtils.FORMULA_TESTO_LIBERO, FormulaUtils.FORMULA_FIRMA]
    }

    @Override
    protected void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c) {
        super.selezionaComune(tca, c)

        switch (tca) {
            case ETipoComuneAtto.CA_PUBB1:
                caricaComuneAffissione1Estero()
                break
            case ETipoComuneAtto.CA_PUBB2:
                caricaComuneAffissione2Estero()
                break
        }
        refreshUi()
    }

    void searchFormulaDefault(String chiave, Boolean salva){
        Map params = [parte: dettaglio.parte, serie: dettaglio.serie, natura: dettaglio.natura, flagDefault:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaMatrimonio(chiave, tipoOperazione, dettaglio, margine)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTATA_TRASCRIZIONE:
                    params.put("progressivo", FormulaUtils.getProgressivoTestataTrascrizione())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestataTrascrizione()
                    break
                case FormulaUtils.FORMULA_TESTATA:
                    params.put("progressivo", FormulaUtils.getProgressivoTestata())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestata()
                    break
                case FormulaUtils.FORMULA_DATI_MATRIMONIO:
                    params.put("progressivo", FormulaUtils.getProgressivoDatiMatrimonio())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDatiMatrimonio()
                    break
                case FormulaUtils.FORMULA_SPOSI:
                    params.put("progressivo", FormulaUtils.getProgressivoSposi())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoSposi()
                    break
                case FormulaUtils.FORMULA_RICHIESTA_FISSA:
                    params.put("progressivo", FormulaUtils.getProgressivoRichiestaFissa())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRichiesta()
                    break
                case FormulaUtils.FORMULA_TESTIMONI:
                    params.put("progressivo", FormulaUtils.getProgressivoTestimoni())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestimoni()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI_FISSA:
                    params.put("documentoPresentatoMatrimonio", margine.documentoPresentatoMatrimonio)
                    params.put("progressivo", FormulaUtils.getProgressivoDocumentiFisso())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDocumentiFisso()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI:
                    params.put("documentoPresentatoMatrimonio", margine.documentoPresentatoMatrimonio)
                    params.put("progressivo", FormulaUtils.getProgressivoDocumenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDocumenti()
                    break
                case FormulaUtils.FORMULA_PUBBLICAZIONI_FISSA:
                    params.put("progressivo", FormulaUtils.getProgressivoPubblicazioniFisso())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoPubblicazioniFisso()
                    break
                case FormulaUtils.FORMULA_PUBBLICAZIONI:
                    params.put("documentoPresentatoMatrimonio", margine.documentoPresentatoMatrimonio)
                    params.put("progressivo", FormulaUtils.getProgressivoPubblicazioni())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoPubblicazioni()
                    break
                case FormulaUtils.FORMULA_MATRIMONIO_CONCORDATARIO:
                    //solo per il default
                    if (dettaglio.convenzioni){
                        params.put("convenzioni", ETipoSiNo.SI.name() + margine.sceltaConvenzioni.toString())
                    } else {
                        params.put("convenzioni", ETipoSiNo.NO.name())
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoMatrimonioConcordatario())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoMatrimonioConcordatario()
                    break
                case FormulaUtils.FORMULA_AMMISSIONE_OLTRE_IMPEDIMENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoAmmissioneOltreImpedimenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoAmmissioneOltreImpedimenti()
                    break
                case FormulaUtils.FORMULA_RICONOSCIMENTO_FIGLI:
                    params.put("progressivo", FormulaUtils.getProgressivoRiconoscimentoFigli())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRiconoscimentoFigli()
                    break
                case FormulaUtils.FORMULA_REGIME_PATRIMONIALE:
                    if (dettaglio.convenzioni){
                        params.put("convenzioni", ETipoSiNo.SI.name() + margine.sceltaConvenzioni.toString())
                    } else {
                        params.put("convenzioni", ETipoSiNo.NO.name())
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoRegimePatrimoniale())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRegimePatrimoniale()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    richiamo = FormulaUtils.getRichiamoChiusura()
                    break
                case FormulaUtils.FORMULA_TESTO_LIBERO:
                    params.put("codiceMinuta", dettaglio.tipoAttoDomain?.codiceMinuta)
                    params.put("categoria", dettaglio.tipoAttoDomain?.categoriaDomain?.codice)
                    richiamo = FormulaUtils.getRichiamoTestoLibero()
                    break
                case FormulaUtils.FORMULA_FIRMA:
                    params.put("progressivo", FormulaUtils.getProgressivoFirma())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoFirma()
                    break
            }
        }
        if (tipoOperazione.isUpdate() && (richiamo != null) ){
            List<Map<String, Object>> formule = statoCivileService.listFormuleMatrimonio(richiamo, params)
            log.info("Recuperate ${(formule?.size()?:0)} formule associate alla chiave ${chiave.toUpperCase()} per l'atto di MAT con id ${dettaglio.id}")
            creaFormulaDefault(chiave, richiamo, params)
            aggiornaFormulaFrammento(chiave, formule, salva, Boolean.FALSE)
        }
    }

    void searchFormuleFrammento(String chiave) {
        Map params = [parte: dettaglio.parte, serie: dettaglio.serie, natura: dettaglio.natura, flagDb:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaMatrimonio(chiave, tipoOperazione, dettaglio, margine)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_DOCUMENTI:
                    params.put("documentoPresentatoMatrimonio", margine.documentoPresentatoMatrimonio)
                    params.put("progressivo", FormulaUtils.getProgressivoDocumenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDocumenti()
                    break
                case FormulaUtils.FORMULA_PUBBLICAZIONI:
                    params.put("documentoPresentatoMatrimonio", margine.documentoPresentatoMatrimonio)
                    params.put("progressivo", FormulaUtils.getProgressivoPubblicazioni())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoPubblicazioni()
                    break
                case FormulaUtils.FORMULA_MATRIMONIO_CONCORDATARIO:
                    params.put("progressivo", FormulaUtils.getProgressivoMatrimonioConcordatario())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoMatrimonioConcordatario()
                    break
                case FormulaUtils.FORMULA_AMMISSIONE_OLTRE_IMPEDIMENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoAmmissioneOltreImpedimenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoAmmissioneOltreImpedimenti()
                    break
                case FormulaUtils.FORMULA_RICONOSCIMENTO_FIGLI:
                    params.put("progressivo", FormulaUtils.getProgressivoRiconoscimentoFigli())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRiconoscimentoFigli()
                    break
                case FormulaUtils.FORMULA_REGIME_PATRIMONIALE:
                    if (dettaglio.convenzioni){
                        params.put("convenzioni", ETipoSiNo.SI.name() + margine.sceltaConvenzioni.toString())
                    } else {
                        params.put("convenzioni", ETipoSiNo.NO.name())
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoRegimePatrimoniale())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRegimePatrimoniale()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    richiamo = FormulaUtils.getRichiamoChiusura()
                    break
                case FormulaUtils.FORMULA_TESTO_LIBERO:
                    params.put("categoria", dettaglio.tipoAttoDomain?.categoriaDomain?.codice)
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoTestoLiberoGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestoLibero()
                    break
            }
        }
        if (richiamo != null){
            Window w = (Window)Executions.createComponents("/restrict/statocivile/formulaListaSelect.zul", self, [tipoAttoEnum: dettaglio.getTipoAttoEnum(), richiamo: richiamo, params: params])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                aggiornaFormulaFrammento(chiave, ((List)event.data), Boolean.FALSE)
            })
            w.doModal()
        }
    }

    List<ETipoFormulaAnnotazioneDaAtto> getChiaviAnnotazioni(){
        return [ETipoFormulaAnnotazioneDaAtto.NAS_1, ETipoFormulaAnnotazioneDaAtto.NAS_2]
    }

    IEstremiAttoNascitaSoggettiDomain getEstremiAttoNascitaDomain(){
        return sposi
    }

    IEstremiAttoMatrimonioDomain getEstremiAttoMatrimonioDomain(){
        return null
    }

    Boolean isCaricamentoFormuleAnnotazioneAbilitato(){
        return ( ( ( dettaglio.natura == ENaturaAtto.O ) || dettaglio.isTrascrizioneMatrimonioCivileSuDelega() ) && dettaglio.isCodRec3() )
    }

    Boolean isCaricamentoAnnotazioniAbilitato(){
        return ( tipoOperazione.isUpdate() && isCaricamentoFormuleAnnotazioneAbilitato() )
    }

    void eliminaAtto(){
        if (deleteRecordEnabled && userModifyEnabled) {
            civMatrimonioService.delete(dettaglio)
        }
    }

    @Command void onSelectAutorita(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (dettaglio.isPartePrima()){
            log.info("Non occorre caricare lista valori 'Autorita' ")
        } else {
            super.onSelectAutorita(event)
        }
    }

    @Command void onSelectSacerdote(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (dettaglio.isSecondaA() || dettaglio.isSecondaB()) {
            CivLuogoMatrimonio c = null
            if (event?.target?.selectedItem instanceof CivLuogoMatrimonio) {
                c = event.target.selectedItem
            }
            datiProvenienza.ministro = c?.ministro
            if (c){
                datiProvenienza.qualita = c.qualita
            }
            refreshUi()
        }
    }

    protected void setComuneMatrimonioAuto(){
        if ( dettaglio.isPartePrima() || dettaglio.isSecondaA()){
            ArcComune comune = statoCivileService.checkComuneMatrimonioAuto()
            if (comune) {
                dettaglio.codiceComuneMatrimonio = comune.codiceComune
                dettaglio.codiceProvinciaMatrimonio = comune.codiceProvincia
                dettaglio.descrizioneComuneMatrimonio = comune.descrizioneComune
                dettaglio.siglaProvinciaMatrimonio = comune.siglaProvincia
            }
        }
    }

    @Command void onSelectCelebrante(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (dettaglio.isSecondaA() || dettaglio.isSecondaB()) {
            CivLuogoMatrimonio c = null
            if (event?.target?.selectedItem instanceof CivLuogoMatrimonio) {
                c = event.target.selectedItem
            }
            datiProvenienza.celebrante = c?.ministro
            refreshUi()
        }
    }

    @Command void onSelectQualificaSacerdote(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (dettaglio.isSecondaA() || dettaglio.isSecondaB()) {
            String q = null
            if (event?.target?.selectedItem instanceof String) {
                q = event.target.selectedItem
            }
            datiProvenienza.qualita = q
            refreshUi()
        }
    }

    @Command void onSelectLuogoMatrimonio(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (dettaglio.isSecondaA() || dettaglio.isSecondaB()) {
            CivLuogoMatrimonio c = null
            if (event?.target?.selectedItem instanceof CivLuogoMatrimonio) {
                c = event.target.selectedItem
            }
            datiProvenienza.nelLuogoMatrimonio = c?.nel
            datiProvenienza.luogoMatrimonio = c?.descrizione
            refreshUi()
        }
    }

    @Command void onCancellaLuogoMatrimonio(){
        onSelectLuogoMatrimonio(null)
    }

    @Command void onSelectConvenzioni(){
        if (dettaglio.convenzioni){
            //se gli sposi sono italiani, scelta_conv è di default '1' e non è modificabile
            //la scelta dell'eventuale legge straniera è selezionabile se almeno uno dei due sposi non è italiano
            //se la nazionalità non è impostata assumere gli sposi stranieri
            if ( (dettaglio.nazionalita1?.id == AnaNazionalita.ID_ITALIA) && (dettaglio.nazionalita2?.id == AnaNazionalita.ID_ITALIA) ){
                margine.sceltaConvenzioni = new Integer(1)
                refreshUi()
            }
        }
    }

    @Command void onSelectNazionalita(){
        if (margine.stampaFormulaLibretto && (!(FormulaUtils.addFormulaMatrimonio(FormulaUtils.FORMULA_MARGINE_LIBRETTO, tipoOperazione, dettaglio, margine))) ){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_formula_libretto_internazionale), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
        refreshUi()
    }

    @Command void onSelectRilascioLibretto(){
        if (!(margine.stampaFormulaLibretto)){
            margine.numeroLibretto = null
            margine.dataLibretto = null
            refreshUi()
        }
    }

    @Command void onChangeLeggeConvenzioni(){
        if (TestoUtils.checkAcapo(margine?.leggeConvenzioni)){
            Messagebox.show(getEtichetta(Etichette.Legge_Convenzioni) + ":\n" + getEtichetta(EtichetteMessaggi.Errore_carattere_a_capo_non_ammesso), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onSelectDocumentoPresentato() {
        switch (margine.documentoPresentatoMatrimonio) {
            case EDocumentoMatrimonio.UNO:
                onCancellaComune(ETipoComuneAtto.CA_PUBB2.name())
                margine.dataAffissioneDa2 = null
                margine.dataAffissioneA2 = null
                margine.consolatoAffisione2 = null
                break
            case EDocumentoMatrimonio.OME:
                onCancellaComune(ETipoComuneAtto.CA_PUBB1.name())
                margine.dataAffissioneDa1 = null
                margine.dataAffissioneA1 = null
                onCancellaComune(ETipoComuneAtto.CA_PUBB2.name())
                margine.dataAffissioneDa2 = null
                margine.dataAffissioneA2 = null
                margine.consolatoAffisione1 = null
                margine.consolatoAffisione2 = null
                break
        }
        refreshUi()
    }

    @Command void onSelectDifettoEta(){
        if ( (dettaglio.difettoEta?:ETipoDifettoEta.D1) == ETipoDifettoEta.D1) {
            dettaglio.tipoAssistenzaMinore1 = null
            dettaglio.tipoAssistenzaMinore2 = null
            datiProvenienza.enteImpedimentoEta = null
            datiProvenienza.estremiDocumentoImpedimentoEta = null
            datiProvenienza.dataAttoImpedimentoEta = null
            onCancellaComune(ETipoComuneAtto.CA_ETA.name())
        }
        if (dettaglio.difettoEta == ETipoDifettoEta.D2){
            dettaglio.tipoAssistenzaMinore2 = null
        }
        if (dettaglio.difettoEta == ETipoDifettoEta.D3){
            dettaglio.tipoAssistenzaMinore1 = null
        }
        refreshUi()
    }

    @Command void onSelectImpedimentoParentela(){
        if ( (dettaglio.impedimentoParentelaMatrimonio?:ETipoImpedimentoParentelaMatrimonio.I0) == ETipoImpedimentoParentelaMatrimonio.I0) {
            datiProvenienza.enteImpedimentoParentela = null
            datiProvenienza.estremiDocumentoImpedimentoParentela = null
            datiProvenienza.dataAttoImpedimentoParentela = null
            onCancellaComune(ETipoComuneAtto.CA_PAR.name())
            refreshUi()
        }
    }

    @Command void onSelectDivietoTemporaneo(){
        if (!(dettaglio.flagDivietoTemporaneo)){
            datiProvenienza.enteDivietoTemporaneo = null
            datiProvenienza.estremiDocumentoDivietoTemporaneo = null
            datiProvenienza.dataAttoDivietoTemporaneo = null
            onCancellaComune(ETipoComuneAtto.CA_TMP.name())
            refreshUi()
        }
    }

    @Command void onSelectTipoDocumentoFineOpposizione(){
        if ( datiProvenienza.tipoDocumentoFineOpposizione == null) {
            datiProvenienza.enteFineOpposizione = null
            datiProvenienza.estremiDocumentoFineOpposizione = null
            datiProvenienza.dataDocumentoFineOpposizione = null
            onCancellaComune(ETipoComuneAtto.CA_FOP.name())
            refreshUi()
        }
    }

    @Command void onSelectDichiarante(){
        if (dettaglio.isCompMatUciVisibile()) {
            switch (datiProvenienza.tipoDichiarante) {
                case ETipoDichiaranteMatrimonioDivorzio.SOSA.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSAIT)]
                    break
            }
            if (datiProvenienza?.tipoComparente) {
                Boolean exists = listaComparente*.get("value").contains(datiProvenienza.tipoComparente)
                if (!(exists)) {
                    datiProvenienza.tipoComparente = null
                }
            }
        }
        onSelectComparente()
    }

    @Command void onSelectComparente(){
        if (dettaglio.isFirmMatUciVisibile()) {
            switch (datiProvenienza.tipoComparente) {
                case ETipoDichiaranteMatrimonioDivorzio.SOSA.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break
                case ETipoDichiaranteMatrimonioDivorzio.SOSAIT.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSAIT),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOIT),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAIT),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.IT),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break
            }
            if (datiProvenienza?.tipoFirmatario) {
                Boolean exists = listaFirmatario*.get("value").contains(datiProvenienza.tipoFirmatario)
                if (!(exists)) {
                    datiProvenienza.tipoFirmatario = null
                }
            }
            checkSoggettoCollegato()
        }
        refreshUi()
    }

    void checkSoggettoCollegato(){
        if (anscOn) {
            if (datiProvenienza?.isComparenteInterprete() && (getInterprete() == null)) {
                CivSoggettoCollegato scInterprete = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.IT)
                listaSoggettiCollegati.add(scInterprete)
            }
        }
    }

    @Command
    void onCheckFlagStranieriNonResidenti() {
        if (datiProvenienza.isStranieriNonResidenti()) {
            DomainUtils.cancellaDatiPubblicazioni(margine)
        } else {
            DomainUtils.cancellaEstremiCertificazione(datiProvenienza)
        }
        refreshUi()
        // se componente costruito invisibile serve forzare ricostruzione con invalidate
        self.getFellow('gbEstremiCertificazione').invalidate()
        // se componente costruito invisibile serve forzare ricostruzione con invalidate
        self.getFellow('gbSezionePubblicazioni').invalidate()
    }

    void storicizzaAtto(Long pkAtto) {
        civMatrimonioService.storicizza(pkAtto)
    }

}