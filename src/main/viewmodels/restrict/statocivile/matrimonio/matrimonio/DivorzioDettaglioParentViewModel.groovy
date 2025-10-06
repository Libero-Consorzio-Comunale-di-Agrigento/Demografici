package restrict.statocivile.matrimonio.matrimonio

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IEstremiAttoMatrimonioDomain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggettiDomain
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
abstract class DivorzioDettaglioParentViewModel extends AttoSoggettiDettaglioParentViewModel{

    CivMatrimonio dettaglio

    final List<ETipoAccordo> listaTipiAccordo = Arrays.asList(ETipoAccordo.values())
    final List<ETipoDivorzio> listaTipiDivorzio = Arrays.asList(ETipoDivorzio.values())
    List<ETipoDivorzioAltro> listaTipiDivorzioAltro = []
    final List<ETipoMargineLaterale> listaMargineLaterale = Arrays.asList(ETipoMargineLaterale.values())

    // Da gestire solo per gli atti in inserimento e non per i consolidati/pregressi
    List<CivFormulaAnnotazione> listaAnnotazioniNascita = []
    List<CivFormulaAnnotazione> listaAnnotazioniMatrimonio = []

    List<Map> listaDichiarante = []
    List<Map> listaComparente = []
    List<Map> listaFirmatario = []

    List<Map> listaRicezioneAtto = []

    Date dataRiferimentoComuneAttoMatrimonio

    final List<ETipoProvvedimentoAutoritaGiudiziaria> listaTipoProvvedimentoAutoritaGiudiziaria = [null] + Arrays.asList(ETipoProvvedimentoAutoritaGiudiziaria.values())
    final List<ETipoProvvedimentoSeparazione> listaTipoProvvedimentoSeparazione = [null] + Arrays.asList(ETipoProvvedimentoSeparazione.values())

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivDivorzioService civDivorzioService

    @WireVariable
    private CivMatrimonioService civMatrimonioService

    void doInit(Window w, Long id, CivTipoAtto tipoAttoDomain) {
        self = w

        initMinuscole(ETipoAtto.MAT, Boolean.TRUE)

        List<Map> eList = []
        eList.addAll(CivMatrimonio.etichetteDomain)
        eList.addAll([Etichette.Comune, Etichette.Celebrato_da, Etichette.Recupero_da_accordo, Etichette.Comune_Atto,
                      Etichette.Sede, Etichette.Annotazione, Etichette.Tipo_Accordo, Etichette.Tipo_Divorzio, Etichette.Estremi_separazione,
                      Etichette.Estremi_Accordo, Etichette.Estremi_Atto_Matrimonio,

                      Etichette.Estremi_Accordo_Separazione, Etichette.Estremi_Conferma_Accordo_Separazione,
                      Etichette.Recupera_Estremi_Atto_Matrimonio, Etichette.Caso_specifico])

        eList.addAll(CivDatiProvenienzaAtto.etichetteDomain)
        eList.addAll(CivMargine.etichetteDomain)
        eList.addAll(CivTestimoniAtto.etichetteDomain)

        // Aggiungo label frammenti specifici
        eList.addAll([Etichette.Sposi, Etichette.Richiesta, Etichette.Documenti, Etichette.Provvedimento_Autorita, Etichette.Altri_Dati])

        // Aggiungo titoli sezioni
        eList.addAll([Etichette.SEZIONE_INFORMAZIONI_ATTO, Etichette.SEZIONE_TIPO_ACCORDO, Etichette.SEZIONE_SPOSI, Etichette.SEZIONE_DATI_ATTO,
                      Etichette.SEZIONE_AVVOCATI, Etichette.SEZIONE_COMPOSIZIONE, Etichette.SEZIONE_REDAZIONE, Etichette.SEZIONE_ANNOTAZIONI_DA_ATTO])

        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_campi_obbligatori_sposi, EtichetteMessaggi.Errore_tipo_divorzio])

        // Aggiungo etichette natura atto
        listaNatura = NaturaUtils.getValoriDivorzio()
        eList.addAll(listaNatura*.etichettaDesc)

        // Aggiungo etichette sesso
        listaSesso = [null] + ESesso.values().toList()
        eList.addAll(ESesso.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo di accordo
        eList.addAll(ETipoAccordo.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo di divorzio
        eList.addAll((Arrays.asList(ETipoDivorzio.values()))*.etichettaDesc)
        eList.addAll(Etichette.Cessazione_Annullamento)

        // Aggiungo etichette per il tipo di atto (se mancata conferma accordo o modifica accordo)
        // nella categoria a testo libero dei divorzi (UAL)
        eList.addAll((Arrays.asList(ETipoDivorzioAltro.values()))*.etichettaDesc)

        // Aggiungo etichette margine laterale
        eList.addAll(Arrays.asList(ETipoMargineLaterale.values())*.etichettaDesc)

        // Aggiungo etichette tipo dichiarante
        eList.addAll((Arrays.asList(ETipoDichiaranteMatrimonioDivorzio.values()))*.etichettaDesc)

        // Aggiungo etichette tipo provvedimento autorità giudiziaria
        eList.addAll((Arrays.asList(ETipoProvvedimentoAutoritaGiudiziaria.values()))*.etichettaDesc)

        // Aggiungo etichette tipo provvedimento separazione
        eList.addAll((Arrays.asList(ETipoProvvedimentoSeparazione.values()))*.etichettaDesc)

        doInitAllAtti(eList)

        //etichette custom
        etichetteCustom = FormUtils.getAttoCustomLabels(ETipoAtto.MAT, etichette)

        msgTitle = getEtichetta(Etichette.Atto_Divorzio)
        tipoAttoLabel = getEtichetta(Etichette.Atto_Divorzio)

        listaComparente = []

        listaFirmatario = []

        listaRicezioneAtto = [null] + [[label: getEtichetta(Etichette.Avvocato_Marito), value: new Integer(1)],
                                       [label: getEtichetta(Etichette.Avvocato_Moglie), value: new Integer(2)],
                                       [label: getEtichetta(Etichette.Entrambi), value: new Integer(3)]]

        resize()

        if (id){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoDomain:tipoAttoDomain])
        }

        etichetteCustom += FormUtils.getTipoDivorzioCustomLabels(dettaglio.tipoAttoDomain.categoriaDomain, etichette)
    }

    protected void caricaListaTipiDivorzioAltro(){
        if (dettaglio.isAvvocatiAltro()){
            listaTipiDivorzioAltro = [ETipoDivorzioAltro.C, ETipoDivorzioAltro.D]
        } else {
            listaTipiDivorzioAltro = [ETipoDivorzioAltro.M, ETipoDivorzioAltro.C, ETipoDivorzioAltro.D]
        }
    }

    protected void caricaListaDichiarante(){
        if (dettaglio.isUfficialeAltro() && datiProvenienza?.isMancataConfermaAccordo(dettaglio.tipoAttoEnum)){
            // In caso di mancata conferma valorizzo la lista del dichiarante per retrocompatibilità
            // ma la disabilito e attivo quella del comparente
            listaDichiarante = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAO),
                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAA),
                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
        } else {
            listaDichiarante = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSA),
                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAA),
                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAO),
                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AOAA)]
        }
    }

    protected void setComuneAttoAuto(){
        if (dettaglio.isAvvocati()){
            ArcComune comune = statoCivileService.getComuneCliente()
            if (comune) {
                dettaglio.codiceComuneMatrimonio = comune.codiceComune
                dettaglio.codiceProvinciaMatrimonio = comune.codiceProvincia
                dettaglio.descrizioneComuneMatrimonio = comune.descrizioneComune
                dettaglio.siglaProvinciaMatrimonio = comune.siglaProvincia
            }
        }
    }

    List<String> getChiaviFormule(){
        return [FormulaUtils.FORMULA_TESTATA_TRASCRIZIONE, FormulaUtils.FORMULA_TESTATA, FormulaUtils.FORMULA_SPOSI, FormulaUtils.FORMULA_RICHIESTA,
                FormulaUtils.FORMULA_DOCUMENTI_ALTRO, FormulaUtils.FORMULA_CHIUSURA, FormulaUtils.FORMULA_TESTO_LIBERO, FormulaUtils.FORMULA_FIRMA]
    }

    void searchFormulaDefault(String chiave, Boolean salva){
        // Nel divorzio bisogna passare la categoria per ogni formula
        Map params = [parte: dettaglio.parte, serie: dettaglio.serie, natura: dettaglio.natura, flagDefault:Boolean.TRUE,
                      categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice]
        Integer richiamo = null
        if (FormulaUtils.addFormulaDivorzio(chiave, tipoOperazione, dettaglio)) {
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
                case FormulaUtils.FORMULA_SPOSI:
                    if (datiProvenienza.avvocato2?.trim() || datiProvenienza.avvocato1?.trim()){
                        params.put("avvocati", ETipoSiNo.SI.name())
                    } else {
                        params.put("avvocati", ETipoSiNo.NO.name())
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoSposi())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoSposi()
                    break
                case FormulaUtils.FORMULA_RICHIESTA:
                    params.put("tipoDivorzio", datiProvenienza.tipoDivorzio?.name())
                    params.put("progressivo", FormulaUtils.getProgressivoRichiesta())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRichiesta()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI_ALTRO:
                    params.put("progressivo", FormulaUtils.getProgressivoDocumentiAltro())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDocumentiAltro()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    richiamo = FormulaUtils.getRichiamoChiusura()
                    break
                case FormulaUtils.FORMULA_TESTO_LIBERO:
                    params.put("codiceMinuta", dettaglio.tipoAttoDomain?.codiceMinuta)
                    richiamo = FormulaUtils.getRichiamoTestoLibero()
                    break
                case FormulaUtils.FORMULA_FIRMA:
                    if (datiProvenienza.avvocato2?.trim() || datiProvenienza.avvocato1?.trim()){
                        params.put("avvocati", ETipoSiNo.SI.name())
                    } else {
                        params.put("avvocati", ETipoSiNo.NO.name())
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoFirma())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoFirma()
                    break
            }
        }
        if (tipoOperazione.isUpdate() && (richiamo != null) ){
            log.info("Tento recupero ${chiave.toUpperCase()} per il record con id ${dettaglio.id}")
            List<Map<String, Object>> formule = statoCivileService.listFormuleDivorzio(richiamo, params)
            creaFormulaDefault(chiave, richiamo, params)
            aggiornaFormulaFrammento(chiave, formule, salva, Boolean.FALSE)
        }
    }

    void searchFormuleFrammento(String chiave) {
        // Nel divorzio bisogna passare la categoria per ogni formula
        Map params = [parte: dettaglio.parte, serie: dettaglio.serie, natura: dettaglio.natura, flagDb:Boolean.TRUE, divorzio: Boolean.TRUE,
                      categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice]
        Integer richiamo = null
        if (FormulaUtils.addFormulaDivorzio(chiave, tipoOperazione, dettaglio)) {
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
                case FormulaUtils.FORMULA_RICHIESTA:
                    params.put("progressivo", FormulaUtils.getProgressivoRichiesta())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRichiesta()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI_ALTRO:
                    params.put("progressivo", FormulaUtils.getProgressivoDocumentiAltro())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDocumentiAltro()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    richiamo = FormulaUtils.getRichiamoChiusura()
                    break
                case FormulaUtils.FORMULA_TESTO_LIBERO:
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
        if (datiProvenienza.tipoDivorzio == ETipoDivorzio.X) {
            return [ETipoFormulaAnnotazioneDaAtto.MAT]
        } else {
            if (dettaglio.isRiconciliazione()){
                return [ETipoFormulaAnnotazioneDaAtto.MAT]
            } else {
                return [ETipoFormulaAnnotazioneDaAtto.NAS_1, ETipoFormulaAnnotazioneDaAtto.NAS_2, ETipoFormulaAnnotazioneDaAtto.MAT]
            }
        }
    }

    IEstremiAttoNascitaSoggettiDomain getEstremiAttoNascitaDomain(){
        return sposi
    }

    IEstremiAttoMatrimonioDomain getEstremiAttoMatrimonioDomain(){
        return sposi
    }

    Boolean isCaricamentoFormuleAnnotazioneAbilitato(){
        return ( ( dettaglio.natura == ENaturaAtto.D ) && dettaglio.tipoAttoDomain?.categoriaDomain?.flagAnagrafe && dettaglio.isCodRec3() )
    }

    Boolean isCaricamentoAnnotazioniAbilitato(){
        return ( tipoOperazione.isUpdate() && isCaricamentoFormuleAnnotazioneAbilitato() )
    }

    @Command void onRecuperaEstremiMatrimonioDaAttoDiMatrimonio() {
        if ( dettaglio.dataNascita1 && dettaglio.cognome1?.trim() && dettaglio.nome1?.trim() &&
             dettaglio.dataNascita2 && dettaglio.cognome2?.trim() && dettaglio.nome2?.trim() ){
            if ( recuperaEstremiMatrimonioDaAttoDiMatrimonio() == 0 ){
                Messagebox.show(getEtichetta(Etichette.Nessun_record_trovato), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_campi_obbligatori_sposi), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    int recuperaEstremiMatrimonioDaAttoDiMatrimonio(){
        IEstremiAttoMatrimonioDomain d = getEstremiAttoMatrimonioDomain()
        if ( (d.getAttoAttoMatrimonio() == null) && ( d.getParteAttoMatrimonio() == null ) && (d.getAnnoAttoMatrimonio() == null) && ( (d.getDescrizioneComuneAttoMatrimonio()?:"") == "") ){
            CivMatrimonio mat = civMatrimonioService.getXDatiAnagraficiSposi(dettaglio.cognome1, dettaglio.nome1, dettaglio.dataNascita1, dettaglio.cognome2, dettaglio.nome2, dettaglio.dataNascita2)
            if (mat){
                ArcComune comune = statoCivileService.getComuneCliente()
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

    void eliminaAtto(){
        if (deleteRecordEnabled && userModifyEnabled) {
            civDivorzioService.delete(dettaglio)
        }
    }

    @Command void onSelectTipoDivorzio() {
        if ((datiProvenienza.tipoDivorzio == ETipoDivorzio.X) && dettaglio.isTribunale()) {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_tipo_divorzio), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
        // Se tipoDivorzio NON vale 'Altro' (ma 'separazione', 'scioglimento', 'cessazione'), devo resettare tipoDivorzioAltro
        // per evitare che rimangano visibili le sezioni legate al valore di tale flag
        if ((datiProvenienza.tipoDivorzio != null) && [ETipoDivorzio.C, ETipoDivorzio.S, ETipoDivorzio.X].contains(datiProvenienza.tipoDivorzio)) {
            if (datiProvenienza.tipoDivorzioAltro == ETipoDivorzioAltro.M){
                // resetto tipoDivorzioAltro e subito dopo aggiorno le liste (!)
                datiProvenienza.tipoDivorzioAltro = null
                onSelectTipoDivorzioAltro()
            } else {
                // resetto tipoDivorzioAltro e basta
                datiProvenienza.tipoDivorzioAltro = null
            }
            // Se ho una separazione devo resettare tipoProvvedimentoSeparazione
            // (al salvataggio cancello gli estremi di provvedimento/accordo di separazione)
            if (dettaglio.isUfficialeAccordo() && (datiProvenienza.tipoDivorzio == ETipoDivorzio.X) ){
                datiProvenienza.tipoProvvedimentoSeparazione = null
            }
        }
        // refs #72274
        // Se UAL e tipoDivorzio vale 'Altro'
        if (dettaglio.isUfficialeAltro() &&
           [ETipoDivorzio.A].contains(datiProvenienza.tipoDivorzio) &&
           [ETipoDivorzioAltro.C, ETipoDivorzioAltro.D].contains(datiProvenienza.tipoDivorzioAltro)){
            datiProvenienza.tipoProvvedimentoSeparazione = null
        }
        refreshUi()
    }

    @Command void onSelectTipoDivorzioAltro(){
        caricaListaDichiarante()
        onSelectDichiarante()
        refreshUi()
    }

    @Command void onSelectTipoProvvedimentoSeparazione(){
        refreshUi()
    }

    // come dichiaranti, io mi aspetto solo due persone, quindi le combinazioni di due elementi:
    // SOSA
    // SOAA
    // SAAO
    // AOAA
    // come comparenti quelli che contengono la coppia dei dichiaranti:
    //se dic SOSA --> comparenti SOSA / SOSAAO / SOSAAOAA
    //se dic SOAA --> comparenti SOAA / SOAAAO
    //se dic SAAO --> comparenti SAAO / SAAOAA
    //se dic AOAA --> comparenti direi solo AOAA... senno gli sposi sarebbero dichiaranti a mio parere
    // per firmatari tutti gli enum, compresi i singoli SO / SA / AO / AA ed anche il caso Nessuno
    @Command void onSelectDichiarante(){
        if(dettaglio.isCompDivScioVisibile()){
            if (dettaglio.isUfficialeAltro() && datiProvenienza?.isMancataConfermaAccordo(dettaglio.tipoAttoEnum)){
                // In caso di mancata conferma valorizzo la lista del dichiarante per retrocompatibilità
                // ma la disabilito e attivo quella del comparente
                listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                            getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAO),
                                            getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                            getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAA),
                                            getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
            } else {
                switch (datiProvenienza.tipoDichiarante) {
                    case ETipoDichiaranteMatrimonioDivorzio.SOSA.name():
                        listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSA),
                                                    getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSAAO),
                                                    getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSAAA),
                                                    getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSAAOAA)]
                        break
                    case ETipoDichiaranteMatrimonioDivorzio.SOAA.name():
                        listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAA),
                                                    getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAOAA)]
                        break
                    case ETipoDichiaranteMatrimonioDivorzio.SAAO.name():
                        listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAO),
                                                    getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAAAO)]
                        break
                    case ETipoDichiaranteMatrimonioDivorzio.AOAA.name():
                        listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AOAA)]
                        break
                    case ETipoDichiaranteMatrimonioDivorzio.SO.name():
                        listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                                    getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAO)]
                        break
                    case ETipoDichiaranteMatrimonioDivorzio.SOAO.name():
                        listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAO)]
                        break
                    case ETipoDichiaranteMatrimonioDivorzio.SA.name():
                        listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                                    getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAA)]
                        break
                    case ETipoDichiaranteMatrimonioDivorzio.SAAA.name():
                        listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAA)]
                        break
                    case ETipoDichiaranteMatrimonioDivorzio.NE.name():
                        listaComparente = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                        break
                }
            }
            if (datiProvenienza?.tipoComparente){
                Boolean exists = listaComparente*.get("value").contains(datiProvenienza.tipoComparente)
                if (!(exists)){
                    datiProvenienza.tipoComparente = null
                }
            }
        }
        onSelectComparente()
    }

    // invocato dalla sezione dic-com-firm
    @Command void onSelectComparente(){
        if (dettaglio.isFirmDivScioVisibile()) {
            List<Map> listaSoloSposiONessuno = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSA),
                                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]

            List<Map> listaSoloSposoONessuno = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]

            List<Map> listaSoloSposaONessuno = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                                         getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
            /*
            List<String> listaAvvocati = [null] + [ETipoDichiaranteMatrimonioDivorzio.SOSAAOAA.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.SOSAAO.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.SOSAAA.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.SOAOAA.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.SAAAAO.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.SOAO.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.SAAO.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.SOAA.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.SAAA.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.AOAA.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.AA.name(),
                                                   ETipoDichiaranteMatrimonioDivorzio.AO.name()]
             */

            switch (datiProvenienza.tipoComparente) {
                case ETipoDichiaranteMatrimonioDivorzio.SOSA.name():
                    listaFirmatario = listaSoloSposiONessuno
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SOSAAO.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSAAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SOSAAA.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSAAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SOAA.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SOAOAA.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAOAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AOAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SAAO.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SAAAAO.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAAAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AOAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break

                case ETipoDichiaranteMatrimonioDivorzio.AOAA.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AOAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SOSAAOAA.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSAAOAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSAAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSAAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOSA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AOAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.AA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SO.name():
                    listaFirmatario = listaSoloSposoONessuno
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SOAO.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SOAO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SO),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SA.name():
                    listaFirmatario = listaSoloSposaONessuno
                    break

                case ETipoDichiaranteMatrimonioDivorzio.SAAA.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SAAA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.SA),
                                                getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break

                case ETipoDichiaranteMatrimonioDivorzio.NE.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteMatrimonioDivorzio.NE)]
                    break
            }
            if (datiProvenienza?.tipoFirmatario) {
                Boolean exists = listaFirmatario*.get("value").contains(datiProvenienza.tipoFirmatario)
                if (!(exists)) {
                    datiProvenienza.tipoFirmatario = null
                }
            }
        }
        refreshUi()
    }

    /***
     * Utilizzato nei divorzi estero (isDivorzioEstero())
     */
    @Command
    void onCheckFlagRichiestaDaPrivatoDichiarante() {
        if (datiProvenienza?.flagRichiestaDaPrivatoDichiarante) {
            datiProvenienza.dichiarazioneGiudiziale = null
            datiProvenienza.dataRichiestaTrascrizione = null
            datiProvenienza.tipoRichiestaTrascrizione = null
            datiProvenienza.tipoDichiarante = null
            datiProvenienza.cognomeDichiarante = null
            datiProvenienza.senzaCognomeDichiarante = null
            datiProvenienza.nomeDichiarante = null
            datiProvenienza.senzaNomeDichiarante = null
            datiProvenienza.sessoDichiarante = null
            datiProvenienza.dataNascitaDichiarante = null
            datiProvenienza.comuneNascitaDichiarante = null
            datiProvenienza.comuneResidenzaDichiarante = null
            datiProvenienza.nazionalitaDichiarante = null
            resetFirmatarioToNE()
        } else {
            datiProvenienza.dichiarazioneGiudiziale = null
            datiProvenienza.autorita = null
            datiProvenienza.comune = null
            datiProvenienza.comuneProvenienza = null
            datiProvenienza.consolato = null
            datiProvenienza.frazione = null
            datiProvenienza.notaRif = null
            datiProvenienza.annoNotaRif = null
            datiProvenienza.dataNotaRif = null
            datiProvenienza.tipoRichiestaTrascrizione = null
            resetFirmatarioToNE()
        }
        refreshUi()
    }

    void storicizzaAtto(Long pkAtto) {
        civDivorzioService.storicizza(pkAtto)
    }

}