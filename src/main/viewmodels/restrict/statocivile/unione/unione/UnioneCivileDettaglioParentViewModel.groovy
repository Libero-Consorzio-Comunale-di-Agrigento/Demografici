package restrict.statocivile.unione.unione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.IEstremiAttoMatrimonioDomain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggettiDomain
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.AttoSoggettiDettaglioParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class UnioneCivileDettaglioParentViewModel extends AttoSoggettiDettaglioParentViewModel{

    CivUnioneCivile dettaglio

    List<Map> listaBoolean = []
    List<Map> listaTipoLuogoCelebrazione
    final List<ETipoCambioCognome> listaCambioCognome = [null] + Arrays.asList(ETipoCambioCognome.values())
    List<Map> listaImpossibilitato = []
    final List<ETipoMargineLaterale> listaMargineLaterale = Arrays.asList(ETipoMargineLaterale.values())
    List<Map<String, ?>> listaConvenzioni = []
    // Da gestire solo per gli atti in inserimento e non per i consolidati/pregressi
    // Le annotazioni di matrimonio sono da gestire solo per la categoria UCN
    List<CivFormulaAnnotazione> listaAnnotazioniNascita = []
    List<CivFormulaAnnotazione> listaAnnotazioniMatrimonio = []
    final List<ETipoDocumentoFineOpposizione> listaTipoDocumentoFineOpposizione = [null] + Arrays.asList(ETipoDocumentoFineOpposizione.values())
    final List<EImpedimentoGenericoUnioneCivile> listaImpedimentoGenerico = [null] + Arrays.asList(EImpedimentoGenericoUnioneCivile.values())

    List<Map> listaDichiarante = []
    List<Map> listaComparente = []
    List<Map> listaFirmatario = []

    Date dataRiferimentoComuneAttoMatrimonio

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivMatrimonioService civMatrimonioService

    @WireVariable
    private CivUnioneCivileService civUnioneCivileService

    void doInit(Window w, Long id, CivTipoAtto tipoAttoDomain) {
        self = w

        initMinuscole(ETipoAtto.UCI)

        saveRecordEnabled = true
        deleteRecordEnabled = true

        List<Map> eList = []
        eList.addAll(CivUnioneCivile.etichetteDomain)
        eList.addAll([Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Data_Redazione_Atto_Originale"), Etichette.getEtichetta("Recupero_da_processo_verbale"),
                      Etichette.getEtichetta("Impossibilitato"),Etichette.getEtichetta("Certificato_del"), Etichette.getEtichetta("Comune_Atto"), Etichette.getEtichetta("Impedimento_generico"),
                      Etichette.getEtichetta("Dati_Certificato"), Etichette.getEtichetta("Documenti_presentati"), Etichette.getEtichetta("Dati_Tribunale"), Etichette.getEtichetta("Autorizzazione_tribunale_di"),
                      Etichette.getEtichetta("Sentenza_n"), Etichette.getEtichetta("Estremi_Atto_Matrimonio"), Etichette.getEtichetta("Recupera_Estremi_Atto_Matrimonio"),
                      Etichette.getEtichetta("Certificato_richiesta_costituzione_1"), Etichette.getEtichetta("Certificato_richiesta_costituzione_2"),
                      Etichette.getEtichetta("Opposizione"), Etichette.getEtichetta("Opposizione_nessuna"), Etichette.getEtichetta("Opposizione_rigetto"), Etichette.getEtichetta("Opposizione_estinzione"),
                      Etichette.getEtichetta("Scelta_legge_da_applicare"), Etichette.getEtichetta("Scelta_regime_separazione"), Etichette.getEtichetta("Annotazione")])

        eList.addAll(CivDatiProvenienzaAtto.etichetteDomain)
        eList.addAll(CivTestimoniAtto.etichetteDomain)
        eList.addAll(CivDocumentoPubblicazione.etichetteDomain)

        // Aggiungo label frammenti specifici
        eList.addAll([Etichette.getEtichetta("Contraenti"), Etichette.getEtichetta("Documenti"), Etichette.getEtichetta("Richiesta"), Etichette.getEtichetta("Testimoni"),
                      Etichette.getEtichetta("Altri_Dati"), Etichette.getEtichetta("Impedimenti"), Etichette.getEtichetta("Scelta_Cognome"),
                      Etichette.getEtichetta("Cambio_sesso"), Etichette.getEtichetta("Convenzioni_Patrimoniali"), Etichette.getEtichetta("Nella_casa_comunale"), Etichette.getEtichetta("Fuori_della_casa_comunale")])

        // Aggiungo titoli sezioni
        eList.addAll([Etichette.getEtichetta("SEZIONE_INFORMAZIONI_ATTO"), Etichette.getEtichetta("SEZIONE_CONTRAENTI"), Etichette.getEtichetta("SEZIONE_DATI_UNIONE_CIVILE"),
                      Etichette.getEtichetta("SEZIONE_ATTO_ORIGINALE"), Etichette.getEtichetta("SEZIONE_TESTIMONI"), Etichette.getEtichetta("SEZIONE_COMPOSIZIONE"),
                      Etichette.getEtichetta("SEZIONE_REDAZIONE"), Etichette.getEtichetta("SEZIONE_ANNOTAZIONI_DA_ATTO")])

        // Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_campi_obbligatori_contraenti"), Etichette.getEtichetta("Errore_carattere_a_capo_non_ammesso")])

        // Aggiungo etichette natura atto
        listaNatura = NaturaUtils.getValoriUnioneCivile()
        eList.addAll(listaNatura*.etichettaDesc)

        // Aggiungo etichette sesso
        listaSesso = [null] + ESesso.values().toList()
        eList.addAll(ESesso.values()*.getEtichettaDesc())

        // Aggiungo etichette per FCC/PDV Impossibilitato
        eList.addAll(Arrays.asList(EImpossibilitato.values())*.etichettaDesc)

        // Aggiungo etichette margine laterale
        eList.addAll(Arrays.asList(ETipoMargineLaterale.values())*.etichettaDesc)

        // Aggiungo etichette scelta cognome
        eList.addAll(Arrays.asList(ETipoCambioCognome.values()).etichettaDesc)

        // Aggiungo etichette fine opposizione
        eList.addAll(ETipoDocumentoFineOpposizione.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo dichiarante
        eList.addAll((Arrays.asList(ETipoDichiaranteUnioneCivileScioglimento.values()))*.etichettaDesc)

        doInitAllAtti(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Atto_Unione_Civile"))
        tipoAttoLabel = getEtichettaEnum(ETipoAtto.UCI)

        listaImpossibilitato = [null]
        listaImpossibilitato.addAll([getDCFItem(EImpossibilitato.C1),
                                     getDCFItem(EImpossibilitato.C2),
                                     getDCFItem(EImpossibilitato.EN)])

        listaBoolean = [[label: getEtichettaEnum(ETipoSiNo.SI), value: Boolean.TRUE], [label:getEtichettaEnum(ETipoSiNo.NO), value: Boolean.FALSE]]

        listaTipoLuogoCelebrazione = [[label: getEtichetta(Etichette.getEtichetta("Nella_casa_comunale")), value: Boolean.TRUE], [label:getEtichetta(Etichette.getEtichetta("Fuori_della_casa_comunale")), value: Boolean.FALSE]]

        listaComparente = []

        listaFirmatario = []

        listaConvenzioni = [[label: getEtichetta(Etichette.getEtichetta("Scelta_regime_separazione")), value: new Integer(1)],
                            [label: getEtichetta(Etichette.getEtichetta("Scelta_legge_da_applicare")), value: new Integer(2)]]

        resize()

        if (id){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoDomain:tipoAttoDomain])
        }
    }

    protected void caricaListaDichiarante(){
        listaDichiarante = [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2)]
    }

    List<String> getChiaviFormule(){
        return [FormulaUtils.FORMULA_TESTATA_TRASCRIZIONE, FormulaUtils.FORMULA_TESTATA, FormulaUtils.FORMULA_CONTRAENTI,
                FormulaUtils.FORMULA_RICHIESTA_FISSA, FormulaUtils.FORMULA_TESTIMONI, FormulaUtils.FORMULA_DOCUMENTI,
                FormulaUtils.FORMULA_AMMISSIONE_OLTRE_IMPEDIMENTI, FormulaUtils.FORMULA_SCELTA_COGNOME,
                FormulaUtils.FORMULA_REGIME_PATRIMONIALE, FormulaUtils.FORMULA_CHIUSURA, FormulaUtils.FORMULA_TESTO_LIBERO, FormulaUtils.FORMULA_FIRMA]
    }

    void searchFormulaDefault(String chiave, Boolean salva){
        Map params = [parte: dettaglio.parte, natura: dettaglio.natura, flagDefault:Boolean.TRUE,
                      searchEqual: Boolean.TRUE, categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice]
        Integer richiamo = null
        if (FormulaUtils.addFormulaUnioneCivile(chiave, tipoOperazione, dettaglio, documentoPubblicazione)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTATA_TRASCRIZIONE:
                    params.put("progressivo", FormulaUtils.getProgressivoTestataTrascrizione())
                    richiamo = FormulaUtils.getRichiamoTestataTrascrizione()
                    break
                case FormulaUtils.FORMULA_TESTATA:
                    params.put("progressivo", FormulaUtils.getProgressivoTestata())
                    richiamo = FormulaUtils.getRichiamoTestata()
                    break
                case FormulaUtils.FORMULA_CONTRAENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoContraenti())
                    richiamo = FormulaUtils.getRichiamoContraenti()
                    break
                case FormulaUtils.FORMULA_RICHIESTA_FISSA:
                    params.put("progressivo", FormulaUtils.getProgressivoRichiestaFissa())
                    richiamo = FormulaUtils.getRichiamoRichiesta()
                    break
                case FormulaUtils.FORMULA_TESTIMONI:
                    params.put("progressivo", FormulaUtils.getProgressivoTestimoni())
                    richiamo = FormulaUtils.getRichiamoTestimoni()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI:
                    params.put("documentoPresentatoPubblicazione", documentoPubblicazione.documentoPresentatoPubblicazione)
                    params.put("progressivo", FormulaUtils.getProgressivoDocumenti())
                    richiamo = FormulaUtils.getRichiamoDocumenti()
                    break
                case FormulaUtils.FORMULA_AMMISSIONE_OLTRE_IMPEDIMENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoAmmissioneOltreImpedimenti())
                    richiamo = FormulaUtils.getRichiamoAmmissioneOltreImpedimenti()
                    break
                case FormulaUtils.FORMULA_SCELTA_COGNOME:
                    if ((dettaglio.cambioCognome1) || (dettaglio.cambioCognome2) ){
                        params.put("sceltaCognome", ETipoSiNo.SI.name() )
                    } else {
                        params.put("sceltaCognome", ETipoSiNo.NO.name())
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoSceltaCognome())
                    richiamo = FormulaUtils.getRichiamoSceltaCognome()
                    break
                case FormulaUtils.FORMULA_REGIME_PATRIMONIALE:
                    if (dettaglio.convenzioni){
                        params.put("convenzioni", ETipoSiNo.SI.name() + margine.sceltaConvenzioni.toString())
                    } else {
                        params.put("convenzioni", ETipoSiNo.NO.name())
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoRegimePatrimoniale())
                    richiamo = FormulaUtils.getRichiamoRegimePatrimoniale()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    richiamo = FormulaUtils.getRichiamoChiusura()
                    break
                case FormulaUtils.FORMULA_TESTO_LIBERO:
                    params.put("codiceMinuta", dettaglio.tipoAttoDomain?.codiceMinuta)
                    richiamo = FormulaUtils.getRichiamoTestoLibero()
                    break
                case FormulaUtils.FORMULA_FIRMA:
                    params.put("progressivo", FormulaUtils.getProgressivoFirma())
                    richiamo = FormulaUtils.getRichiamoFirma()
                    break
            }
        }
        if (tipoOperazione.isUpdate() && (richiamo != null) ){
            log.info("Tento recupero ${chiave.toUpperCase()} per il record con id ${dettaglio.id}")
            List<Map<String, Object>> formule = gsdService.listFormuleUnioneCivile(richiamo, params)
            creaFormulaDefault(chiave, richiamo, params)
            aggiornaFormulaFrammento(chiave, formule, salva, Boolean.FALSE)
        }
    }

    void searchFormuleFrammento(String chiave) {
        Map params = [parte: dettaglio.parte, natura: dettaglio.natura, flagDb:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaUnioneCivile(chiave, tipoOperazione, dettaglio, documentoPubblicazione)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTATA:
                    params.put("progressivo", FormulaUtils.getProgressivoTestata())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestata()
                    break
                case FormulaUtils.FORMULA_CONTRAENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoContraenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoContraenti()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoDocumenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDocumenti()
                    break
                case FormulaUtils.FORMULA_AMMISSIONE_OLTRE_IMPEDIMENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoAmmissioneOltreImpedimenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoAmmissioneOltreImpedimenti()
                    break
                case FormulaUtils.FORMULA_SCELTA_COGNOME:
                    if ((dettaglio.cambioCognome1) || (dettaglio.cambioCognome2) ){
                        params.put("sceltaCognome", ETipoSiNo.SI.name() )
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoSceltaCognome())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoSceltaCognome()
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
            Window w = (Window) Executions.createComponents("/restrict/statocivile/formulaListaSelect.zul", self, [tipoAttoEnum: dettaglio.getTipoAttoEnum(), richiamo: richiamo, params: params])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                aggiornaFormulaFrammento(chiave, ((List)event.data), Boolean.FALSE)
            })
            w.doModal()
        }
    }

    List<ETipoFormulaAnnotazioneDaAtto> getChiaviAnnotazioni(){
        List<ETipoFormulaAnnotazioneDaAtto> l = [ETipoFormulaAnnotazioneDaAtto.NAS_1, ETipoFormulaAnnotazioneDaAtto.NAS_2]
        if (dettaglio.isUnioneCivileConiugi()){
            l.add(ETipoFormulaAnnotazioneDaAtto.MAT)
        }
        return l
    }

    IEstremiAttoNascitaSoggettiDomain getEstremiAttoNascitaDomain(){
        return sposi
    }

    IEstremiAttoMatrimonioDomain getEstremiAttoMatrimonioDomain(){
        return sposi
    }

    Boolean isCaricamentoFormuleAnnotazioneAbilitato(){
        return ( ( dettaglio.natura == ENaturaAtto.O ) && dettaglio.isCodRec3() )
    }

    Boolean isCaricamentoAnnotazioniAbilitato(){
        return ( tipoOperazione.isUpdate() && isCaricamentoFormuleAnnotazioneAbilitato() )
    }
    
    protected void setComuneUciAuto(){
        if ( dettaglio.isPartePrima()){
            ArcComune comune = gsdService.checkComuneMatrimonioAuto()
            if (comune) {
                dettaglio.codiceComuneMatrimonio = comune.codiceComune
                dettaglio.codiceProvinciaMatrimonio = comune.codiceProvincia
                dettaglio.descrizioneComuneMatrimonio = comune.descrizioneComune
                dettaglio.siglaProvinciaMatrimonio = comune.siglaProvincia
            }
        }
    }

    void eliminaAtto(){
        if (deleteRecordEnabled && userModifyEnabled) {
            civUnioneCivileService.delete(dettaglio)
        }
    }

    @Command void onRecuperaEstremiMatrimonioDaAttoDiMatrimonio() {
        if ( dettaglio.dataNascita1 && dettaglio.cognome1?.trim() && dettaglio.nome1?.trim() &&
             dettaglio.dataNascita2 && dettaglio.cognome2?.trim() && dettaglio.nome2?.trim() ){
            if ( recuperaEstremiMatrimonioDaAttoDiMatrimonio() == 0 ){
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_campi_obbligatori_contraenti")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    int recuperaEstremiMatrimonioDaAttoDiMatrimonio(){
        IEstremiAttoMatrimonioDomain d = getEstremiAttoMatrimonioDomain()
        if ( (d.getAttoAttoMatrimonio() == null) && ( d.getParteAttoMatrimonio() == null ) && (d.getAnnoAttoMatrimonio() == null) && ( (d.getDescrizioneComuneAttoMatrimonio()?:"") == "") ){
            CivMatrimonio mat = civMatrimonioService.getXDatiAnagraficiSposi(dettaglio.cognome1, dettaglio.nome1, dettaglio.dataNascita1,
                    dettaglio.cognome2, dettaglio.nome2, dettaglio.dataNascita2)
            if (mat){
                ArcComune comune = gsdService.getComuneCliente()
                CivDatiProvenienzaAtto dpaMat = civMatrimonioService.getDatiProvenienzaByUkAtto(mat.idAtto)
                if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
                    DomainUtils.initEstremiAttoMatrimonioFromMatUciNuovaGestioneAnnotazioni(sposi, mat, comune, dpaMat, anscOn)
                } else {
                    DomainUtils.initEstremiAttoMatrimonioFromMatUci(sposi, mat, comune, dpaMat, anscOn)
                }

                onAggiornaDataRiferimentoMatrimonio()
                refreshUi()
                return 1
            } else {
                return 0
            }
        }
        return -1
    }

    @Command void onAggiornaDataRiferimentoMatrimonio(){
        IEstremiAttoMatrimonioDomain d = getEstremiAttoMatrimonioDomain()
        dataRiferimentoComuneAttoMatrimonio = DataUtils.getDataAttoRif(null, d.getAnnoAttoMatrimonio())
        BindUtils.postNotifyChange(null, null, this, "dataRiferimentoComuneAttoMatrimonio")
    }

    @Command void onSelectConvenzioni(){
        if (dettaglio.convenzioni){
            //se gli sposi sono italiani, scelta_conv è di default '1' e non è modificabile
            //la scelta dell'eventuale legge straniera è selezionabile se almeno uno dei due sposi non è italiano
            //se la nazionalità non è impostata assumere gli sposi stranieri
            if ( (dettaglio.nazionalita1?.codCi == AnaCittadinanza.ID_ITALIA) && (dettaglio.nazionalita2?.codCi == AnaCittadinanza.ID_ITALIA) ){
                margine.sceltaConvenzioni = new Integer(1)
                refreshUi()
            }
        }
    }

    @Command void onChangeLeggeConvenzioni(){
        if (TestoUtils.checkAcapo(margine?.leggeConvenzioni)){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Legge_Convenzioni")) + ":\n" + getEtichetta(Etichette.getEtichetta("Errore_carattere_a_capo_non_ammesso")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
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
        switch (datiProvenienza.tipoDichiarante) {
            case ETipoDichiaranteUnioneCivileScioglimento.C1C2.name():
                listaComparente = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2IT)]
                break
        }
        if (datiProvenienza?.tipoComparente){
            Boolean exists = listaComparente*.get("value").contains(datiProvenienza.tipoComparente)
            if (!(exists)){
                datiProvenienza.tipoComparente = null
            }
        }
        onSelectComparente()
    }

    @Command void onSelectComparente(){
        if (dettaglio.isFirmMatUciVisibile()) {
            switch (datiProvenienza.tipoComparente) {
                case ETipoDichiaranteUnioneCivileScioglimento.C1C2.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                    break
                case ETipoDichiaranteUnioneCivileScioglimento.C1C2IT.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2IT),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1IT),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2IT),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.IT),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
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
        civUnioneCivileService.storicizza(pkAtto)
    }

}