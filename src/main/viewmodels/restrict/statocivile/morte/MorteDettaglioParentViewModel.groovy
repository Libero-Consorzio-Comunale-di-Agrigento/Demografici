package restrict.statocivile.morte

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IEstremiAttoMatrimonioDomain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggettiDomain
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.BindingParam
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
import restrict.statocivile.TraitTemplateTrasportoESeppellimento

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class MorteDettaglioParentViewModel extends AttoSoggettiDettaglioParentViewModel
                    implements TraitTemplateTrasportoESeppellimento {

    CivMorte dettaglio

    final List<ETipoMargineLaterale> listaMargineLaterale = Arrays.asList(ETipoMargineLaterale.values())

    // Da gestire solo per gli atti in inserimento e non per i consolidati/pregressi
    List<CivFormulaAnnotazione> listaAnnotazioniNascita = []
    List<AnaStatoCivile> listaStatoCivile = []

    List<Map> listaComparente = []
    List<Map> listaFirmatario = []

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivMorteService civMorteService

    @WireVariable
    private AnaStatoCivileService anaStatoCivileService

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    // ------------------ Servizi per Trait TrasportoESeppellimento ---------------------
    //
    @WireVariable
    private CivRegistroDocumentiUscitaService civRegistroDocumentiUscitaService
    //
    // -------------------- ---------------------------------- --------------------------

    void doInit(Window w, Long id, CivTipoAtto tipoAttoDomain) {
        self = w

        initMinuscole(ETipoAtto.MOR)

        List<Map> eList = []
        eList.addAll(CivMorte.etichetteDomain)
        eList.addAll([Etichette.Imprecisato, Etichette.Comune, Etichette.Data_Redazione_Atto_Originale,
                      Etichette.Coniuge, Etichette.Genitori, Etichette.Interprete, Etichette.Dati_Dichiarante,
                      Etichette.Tribunale, Etichette.Sentenza_n, Etichette.Atto_morte_n,
                      Etichette.Ricevuto_da, Etichette.Documento_i, Etichette.Avviso_morte, Etichette.Comune_Atto, Etichette.Annotazione])

        eList.addAll(CivDatiProvenienzaAtto.etichetteDomain)
        eList.addAll(CivTrasportoESeppellimento.etichetteDomain)

        // Aggiungo label frammenti specifici
        eList.addAll([Etichette.Dati_Decesso, Etichette.Altri_Dati])

        // Aggiungo titoli sezioni
        eList.addAll([Etichette.SEZIONE_INFORMAZIONI_ATTO, Etichette.SEZIONE_DATI_DECEDUTO_A, Etichette.SEZIONE_DATI_DECESSO,
                      Etichette.SEZIONE_ATTO_ORIGINALE, Etichette.SEZIONE_ESTREMI_TRASPORTO, Etichette.SEZIONE_ESTREMI_CREMAZIONE,
                      Etichette.SEZIONE_COMPOSIZIONE, Etichette.SEZIONE_REDAZIONE, Etichette.SEZIONE_ANNOTAZIONI_DA_ATTO])

        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Warn_Data_Nascita_Anni_Alternativi, EtichetteMessaggi.Errore_data_futura])

        // Aggiungo etichette natura atto
        listaNatura = NaturaUtils.getValoriDecesso()
        eList.addAll(listaNatura*.etichettaDesc)

        // Aggiungo etichette sesso
        listaSesso = [null] + ESesso.values().toList()
        eList.addAll(ESesso.values()*.getEtichettaDesc())

        // Aggiungo etichette margine laterale
        eList.addAll(Arrays.asList(ETipoMargineLaterale.values())*.etichettaDesc)

        // Aggiungo etichette tipo comparente
        eList.addAll((Arrays.asList(ETipoDichiaranteMorte.values()))*.etichettaDesc)

        // Aggiungo etichette sezione trasporto
        eList.addAll(etichetteTsDefault)

        // Aggiungo etichette avviso salvataggio annotazione con nascita non presente
        eList.addAll(EtichetteMessaggi.Ask_annotazione_nascita_mancante)
        eList.addAll(ETipoSalvataggioAnnotazioneComuneCliente.values()*.getEtichettaDesc())

        doInitAllAtti(eList)

        initTrasporto(civRegistroDocumentiUscitaService)

        msgTitle = getEtichetta(Etichette.Atto_Morte)
        tipoAttoLabel = getEtichettaEnum(ETipoAtto.MOR)

        resize()

        if (id){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoDomain:tipoAttoDomain])
        }
    }

    protected void caricaListaComparente(){
        listaComparente = [getDCFItem(ETipoDichiaranteMorte.C1),
                           getDCFItem(ETipoDichiaranteMorte.C1IT)]
    }

    void allineaTestoTrasportoMinuscole(){
        DomainUtils.allineaTestoMinuscole(trasporto, minuscole)
    }

    void caricaListaStatoCivile(){
        listaStatoCivile = [null]
        if (dettaglio.sesso){
            listaStatoCivile.addAll(anaStatoCivileService.listAllBySesso(dettaglio.sesso))
        }
        BindUtils.postNotifyChange(null, null, this, "listaStatoCivile")
    }

    protected void setComuneDecessoAuto(){
        if (dettaglio.isPartePrima() || dettaglio.isSecondaB()) {
            ArcComune comune = statoCivileService.checkComuneDecessoAuto()
            if (comune) {
                riempiComune(dettaglio.comuneMorte, comune)
            }
        }
    }

    List<String> getChiaviFormule(){
        return [FormulaUtils.FORMULA_TESTATA_TRASCRIZIONE, FormulaUtils.FORMULA_TESTATA, FormulaUtils.FORMULA_DICHIARANTE_FISSA,
                FormulaUtils.FORMULA_DATI_DECESSO, FormulaUtils.FORMULA_CONGIUNTI, FormulaUtils.FORMULA_DATI_INTEGRATIVI,
                FormulaUtils.FORMULA_APOSTILLE, FormulaUtils.FORMULA_CHIUSURA, FormulaUtils.FORMULA_TESTO_LIBERO, FormulaUtils.FORMULA_FIRMA]
    }

    void searchFormulaDefault(String chiave, Boolean salva){
        Map params = [parte: dettaglio.parte, serie: dettaglio.serie, natura: dettaglio.natura, flagDefault:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaDecesso(chiave, tipoOperazione, dettaglio)) {
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
                case FormulaUtils.FORMULA_DICHIARANTE_FISSA:
                    params.put("progressivo", FormulaUtils.getProgressivoDichiaranteFisso())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDichiaranteFisso()
                    break
                case FormulaUtils.FORMULA_DATI_DECESSO:
                    params.put("progressivo", FormulaUtils.getProgressivoDatiDecesso())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDatiDecesso()
                    break
                case FormulaUtils.FORMULA_CONGIUNTI:
                    params.put("progressivo", FormulaUtils.getProgressivoCongiunti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoCongiunti()
                    break
                case FormulaUtils.FORMULA_DATI_INTEGRATIVI:
                    params.put("progressivo", FormulaUtils.getProgressivoDatiIntegrativi())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDatiIntegrativi()
                    break
                case FormulaUtils.FORMULA_APOSTILLE:
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoApostilleGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoApostille()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    params.put("tipoComparente", datiProvenienza.tipoComparente)
                    params.put("tipoFirmatario", datiProvenienza.tipoFirmatario)
                    params.put("comprensioneDichiarante", datiProvenienza.comprensioneDichiarante?.id)
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
            log.info("Tento recupero ${chiave.toUpperCase()} per il record con id ${dettaglio.id}")
            List<Map<String, Object>> formule = statoCivileService.listFormuleDecesso(richiamo, params)
            creaFormulaDefault(chiave, richiamo, params)
            aggiornaFormulaFrammento(chiave, formule, salva, Boolean.FALSE)
        }
    }

    void searchFormuleFrammento(String chiave) {
        Map params = [parte: dettaglio.parte, serie: dettaglio.serie, natura: dettaglio.natura, flagDb:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaDecesso(chiave, tipoOperazione, dettaglio)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_DATI_INTEGRATIVI:
                    params.put("progressivo", FormulaUtils.getProgressivoDatiIntegrativi())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDatiIntegrativi()
                    break
                case FormulaUtils.FORMULA_APOSTILLE:
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoApostilleGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoApostille()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    params.put("tipoComparente", datiProvenienza.tipoComparente)
                    params.put("tipoFirmatario", datiProvenienza.tipoFirmatario)
                    params.put("comprensioneDichiarante", datiProvenienza.comprensioneDichiarante?.id)
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
            Window w = (Window) Executions.createComponents("/restrict/statocivile/formulaListaSelect.zul", self, [tipoAttoEnum: dettaglio.getTipoAttoEnum(), richiamo: richiamo, params: params])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                aggiornaFormulaFrammento(chiave, ((List)event.data), Boolean.FALSE)
            })
            w.doModal()
        }
    }

    List<ETipoFormulaAnnotazioneDaAtto> getChiaviAnnotazioni(){
        return [ETipoFormulaAnnotazioneDaAtto.NAS_1]
    }

    IEstremiAttoNascitaSoggettiDomain getEstremiAttoNascitaDomain(){
        return margine
    }

    IEstremiAttoMatrimonioDomain getEstremiAttoMatrimonioDomain(){
        return null
    }

    Boolean isCaricamentoFormuleAnnotazioneAbilitato(){
        return ( ( dettaglio.natura == ENaturaAtto.O ) && dettaglio.isCodRec3() )
    }

    Boolean isCaricamentoAnnotazioniAbilitato(){
        return ( tipoOperazione.isUpdate() && isCaricamentoFormuleAnnotazioneAbilitato() )
    }

    @Override
    protected void caricaDatiSoggetto1(AnaAnagrafeBaseDomain ana){
        super.caricaDatiSoggetto1(ana)

        onSelectSesso(null)

       if (dettaglio.isConiugato()) {
            if ((ana instanceof AnaAnagrafe) && ana.coniuge?.idAnagrafe != null) {
                AnaAnagrafe anaC = anaAnagrafeService.get(ana.coniuge?.idAnagrafe, [fetch:[[campo:'nazionalita', tipo: JoinType.LEFT]]])
                caricaDatiConiuge(anaC)
            } else {
                // se il soggetto è stato recuperato da anpr oppure se viene da anaana e coniuge.idAnagrafe = null
                caricaDatiConiuge(null)
                dettaglio.cognomeConiuge = ana.coniuge?.cognome
                dettaglio.nomeConiuge = ana.coniuge?.nome
                // se arrivo da anpr ho anche altre info di dettaglio da inserire in maschera
                if (ana instanceof AnpAnagrafe) {
                    dettaglio.sessoConiuge = ana.coniuge?.sesso
                    dettaglio.dataNascitaConiuge = ana.coniuge?.dataNascita

                    dettaglio.comuneNascitaConiuge.codice = ana.coniuge?.comuneNascita?.codice
                    dettaglio.comuneNascitaConiuge.codiceProvincia = ana.coniuge?.comuneNascita?.codiceProvincia
                    dettaglio.comuneNascitaConiuge.siglaProvincia = ana.coniuge?.comuneNascita?.siglaProvincia
                    dettaglio.comuneNascitaConiuge.descrizione = ana.coniuge?.comuneNascita?.descrizione

                    dettaglio.nazionalitaConiuge = ana.coniuge?.nazionalita

                    dettaglio.comuneResidenzaConiuge.codice = ana.coniuge?.comuneResidenza?.codice
                    dettaglio.comuneResidenzaConiuge.codiceProvincia = ana.coniuge?.comuneResidenza?.codiceProvincia
                    dettaglio.comuneResidenzaConiuge.siglaProvincia = ana.coniuge?.comuneResidenza?.siglaProvincia
                    dettaglio.comuneResidenzaConiuge.descrizione = ana.coniuge?.comuneResidenza?.descrizione
                }
            }
        }

        dettaglio.cognomePadre = ana.cognomePadre
        dettaglio.nomePadre = ana.nomePadre

        dettaglio.cognomeMadre = ana.cognomeMadre
        dettaglio.nomeMadre = ana.nomeMadre

        DomainUtils.allineaTestoMinuscole(getAtto(), minuscole)
    }

    @Override
    protected void caricaDatiConiuge(AnaAnagrafeBaseDomain ana){
        dettaglio.cognomeConiuge = ana?.cognome
        dettaglio.nomeConiuge = ana?.nome
        dettaglio.sessoConiuge = ana?.sesso
        dettaglio.dataNascitaConiuge = ana?.dataNascita

        dettaglio.comuneNascitaConiuge.codice = ana?.codiceComuneNascita
        dettaglio.comuneNascitaConiuge.descrizione = ana?.descrizioneComuneNascita
        dettaglio.comuneNascitaConiuge.codiceProvincia = ana?.codiceProvinciaNascita
        dettaglio.comuneNascitaConiuge.siglaProvincia = ana?.siglaProvinciaNascita

        dettaglio.nazionalitaConiuge = ana?.nazionalita

        dettaglio.comuneResidenzaConiuge.codice = ana?.comuneResidenza?.codice
        dettaglio.comuneResidenzaConiuge.descrizione = ana?.comuneResidenza?.descrizione
        dettaglio.comuneResidenzaConiuge.codiceProvincia = ana?.comuneResidenza?.codiceProvincia
        dettaglio.comuneResidenzaConiuge.siglaProvincia = ana?.comuneResidenza?.siglaProvincia

        super.caricaDatiConiuge(ana)
    }

    @Override
    protected void cancellaAnagraficaConiuge(){
        caricaDatiConiuge(null)
        refreshUi()
    }

    @Override
    protected void caricaDatiPadre(AnaAnagrafeBaseDomain ana){
        dettaglio.cognomePadre = ana.cognome
        dettaglio.nomePadre = ana.nome

        super.caricaDatiPadre(ana)
    }

    @Override
    protected void caricaDatiMadre(AnaAnagrafeBaseDomain ana){
        dettaglio.cognomeMadre = ana.cognome
        dettaglio.nomeMadre = ana.nome

        super.caricaDatiMadre(ana)
    }

    void eliminaAtto(){
        if (deleteRecordEnabled && userModifyEnabled) {
            civMorteService.delete(dettaglio)
        }
    }

    @Command void onSelectStatoCivile(){
        refreshUi()
    }

    @Command void onSelectLuogoDecesso(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        CivLuogoDecesso c = null
        if (event?.target?.selectedItem instanceof CivLuogoDecesso) {
            c = event.target.selectedItem
        }
        datiProvenienza.nelLuogoMorte = c?.nel
        datiProvenienza.luogoMorte1 = c?.descrizione
        refreshUi()
    }

    /*
    @Command void onChangeLuogoDecesso(@ContextParam(ContextType.TRIGGER_EVENT) InputEvent event){
        if ((event.previousValue?:"") != (event.value?:"")){
            log.info("onChangeLuogoDecesso " + (event.value?:""))
            // 21/12/2021 commentata per evitare che l'articolo venga vuotato se l'utente digita il luogo anziché selezionare da popup
            //datiProvenienza.nelLuogoMorte = null
        }
    }
    */

    @Command void onCancellaLuogoDecesso(){
        onSelectLuogoDecesso(null)
    }

    @Command void onSelectRicevuto(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (dettaglio.isSecondaB()) {
            String q = null
            if (event?.target?.selectedItem instanceof String) {
                q = event.target.selectedItem
            }
            datiProvenienza.ricevuto = q
            refreshUi()
        }
    }

    @Command void onCancellaRicevuto(){
        onSelectRicevuto(null)
    }

    @Command void onSelectDocumentoDecesso(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (dettaglio.isSecondaB()) {
            String q = null
            if (event?.target?.selectedItem instanceof String) {
                q = event.target.selectedItem
            }
            datiProvenienza.documentoDecesso = q
            refreshUi()
        }
    }

    @Command void onCancellaDocumentoDecesso(){
        onSelectDocumentoDecesso(null)
    }

    @Command void onSelectSesso(@BindingParam("campoAnagrafe") String campoAnagrafe) {
        caricaListaStatoCivile()
        if(campoAnagrafe){
            onAggiornaAna(campoAnagrafe)
        }
    }

    @Command void onCheckDataNascitaAnni() {
        if ( (dettaglio.anni != null) && (dettaglio.dataNascita != null) ){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Warn_Data_Nascita_Anni_Alternativi), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
        }
    }

    @Command void onSelectDataMorte(){
        if (DataUtils.isDataFutura(dettaglio.dataMorte)){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_data_futura), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onSelectComparente(){
        if (dettaglio.isCompFirmMorVisibile()) {
            switch (datiProvenienza.tipoComparente) {
                case ETipoDichiaranteMorte.C1.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMorte.C1),
                                                getDCFItem(ETipoDichiaranteMorte.NE)]
                    break
                case ETipoDichiaranteMorte.C1IT.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMorte.C1),
                                                getDCFItem(ETipoDichiaranteMorte.C1IT)]
                    break
                case ETipoDichiaranteMorte.NE.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMorte.NE)]
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

    void storicizzaAtto(Long pkAtto) {
        civMorteService.storicizza(pkAtto)
    }

}