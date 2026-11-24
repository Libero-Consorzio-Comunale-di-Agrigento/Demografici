package restrict.statocivile.unione.unione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
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
abstract class ScioglimentoDettaglioParentViewModel extends AttoSoggettiDettaglioParentViewModel{

    CivUnioneCivile dettaglio

    final List<ETipoAccordo> listaTipiAccordo = Arrays.asList(ETipoAccordo.values())
    final List<ETipoDivorzioAltro> listaTipiDivorzioAltro = [ETipoDivorzioAltro.M] + [ETipoDivorzioAltro.A]
    final List<ETipoMargineLaterale> listaMargineLaterale = Arrays.asList(ETipoMargineLaterale.values())
    // Da gestire solo per gli atti in inserimento e non per i consolidati/pregressi
    List<CivFormulaAnnotazione> listaAnnotazioniNascita = []
    List<CivFormulaAnnotazione> listaAnnotazioniMatrimonio = []

    List<Map> listaDichiarante = []
    List<Map> listaComparente = []
    List<Map> listaFirmatario = []

    Date dataRiferimentoComuneAttoMatrimonio

    final List<ETipoProvvedimentoAutoritaGiudiziaria> listaTipoProvvedimentoAutoritaGiudiziaria = [null] + Arrays.asList(ETipoProvvedimentoAutoritaGiudiziaria.values())

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivScioglimentoService civScioglimentoService

    @WireVariable
    private CivUnioneCivileService civUnioneCivileService

    void doInit(Window w, Long id, CivTipoAtto tipoAttoDomain) {
        self = w

        initMinuscole(ETipoAtto.UCI, Boolean.TRUE)

        List<Map> eList = []
        eList.addAll(CivUnioneCivile.etichetteDomain)
        eList.addAll([Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Recupero_da_accordo"), Etichette.getEtichetta("Comune_Atto"),
                      Etichette.getEtichetta("Sede"), Etichette.getEtichetta("Annotazione"), Etichette.getEtichetta("Tipo_Accordo"), Etichette.getEtichetta("Caso_specifico"),
                      Etichette.getEtichetta("Estremi_Accordo"), Etichette.getEtichetta("Estremi_Atto_Unione_Civile"), Etichette.getEtichetta("Recupera_Estremi_Atto_Unione_Civile")])

        eList.addAll(CivDatiProvenienzaAtto.etichetteDomain)
        eList.addAll(CivMargine.etichetteDomain)
        eList.addAll(CivTestimoniAtto.etichetteDomain)

        // Aggiungo label frammenti specifici
        eList.addAll([Etichette.getEtichetta("Richiedenti"), Etichette.getEtichetta("Richiesta"), Etichette.getEtichetta("Documenti"), Etichette.getEtichetta("Provvedimento_Autorita")])

        // Aggiungo titoli sezioni
        eList.addAll([Etichette.getEtichetta("SEZIONE_INFORMAZIONI_ATTO"), Etichette.getEtichetta("SEZIONE_TIPO_ACCORDO"), Etichette.getEtichetta("SEZIONE_CONTRAENTI"), Etichette.getEtichetta("SEZIONE_SPOSI"), Etichette.getEtichetta("SEZIONE_DATI_ATTO"),
                      Etichette.getEtichetta("SEZIONE_AVVOCATI"), Etichette.getEtichetta("SEZIONE_COMPOSIZIONE"), Etichette.getEtichetta("SEZIONE_REDAZIONE"), Etichette.getEtichetta("SEZIONE_ANNOTAZIONI_DA_ATTO")])
        // Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_campi_obbligatori_contraenti")])

        // Aggiungo etichette natura atto
        listaNatura = NaturaUtils.getValoriScioglimento()
        eList.addAll(listaNatura*.etichettaDesc)

        // Aggiungo etichette tipo di accordo
        eList.addAll(ETipoAccordo.values()*.getEtichettaDesc())

        // Aggiungo etichette sesso
        listaSesso = [null] + ESesso.values().toList()
        eList.addAll(ESesso.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo dichiarante
        eList.addAll((Arrays.asList(ETipoDichiaranteUnioneCivileScioglimento.values()))*.etichettaDesc)

        // Aggiungo etichette tipo provvedimento
        eList.addAll((Arrays.asList(ETipoProvvedimentoAutoritaGiudiziaria.values()))*.etichettaDesc)

        // Aggiungo etichette per il tipo di atto (se mancata conferma accordo o modifica accordo)
        // nella categoria a testo libero degli scioglimenti (UAL)
        eList.addAll((Arrays.asList(ETipoDivorzioAltro.values()))*.etichettaDesc)

        // Aggiungo etichette margine laterale
        eList.addAll(Arrays.asList(ETipoMargineLaterale.values())*.etichettaDesc)

        doInitAllAtti(eList)

        //etichette custom
        etichetteCustom = FormUtils.getAttoCustomLabels(ETipoAtto.UCI, etichette)

        msgTitle = getEtichetta(Etichette.getEtichetta("Atto_Scioglimento"))
        tipoAttoLabel = getEtichetta(Etichette.getEtichetta("Atto_Scioglimento"))

        listaComparente = [null]
        listaFirmatario = [null]

        resize()

        if (id){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoDomain:tipoAttoDomain])
        }
    }

    protected void caricaListaDichiarante(){
        if (dettaglio.isUfficialeAltro() && datiProvenienza?.isMancataConfermaAccordo(dettaglio.tipoAttoEnum)){
            // In caso di mancata conferma valorizzo la lista del dichiarante per retrocompatibilità
            // ma la disabilito e attivo quella del comparente
            listaDichiarante = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                         getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A1),
                                         getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                         getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A2),
                                         getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
        } else {
            listaDichiarante = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                         getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                         getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.CI),
                                         getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A2),
                                         getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A1),
                                         getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1A2)]
        }
    }

    protected void setComuneAttoAuto(){
        if (dettaglio.isAvvocati()){
            ArcComune comune = gsdService.getComuneCliente()
            if (comune) {
                dettaglio.codiceComuneMatrimonio = comune.codiceComune
                dettaglio.codiceProvinciaMatrimonio = comune.codiceProvincia
                dettaglio.descrizioneComuneMatrimonio = comune.descrizioneComune
                dettaglio.siglaProvinciaMatrimonio = comune.siglaProvincia
            }
        }
    }

    List<String> getChiaviFormule(){
        return [FormulaUtils.FORMULA_TESTATA_TRASCRIZIONE, FormulaUtils.FORMULA_TESTATA, FormulaUtils.FORMULA_RICHIEDENTI_FISSA,
                FormulaUtils.FORMULA_RICHIESTA, FormulaUtils.FORMULA_DOCUMENTI_ALTRO,
                FormulaUtils.FORMULA_CHIUSURA, FormulaUtils.FORMULA_TESTO_LIBERO, FormulaUtils.FORMULA_FIRMA]
    }

    void searchFormulaDefault(String chiave, Boolean salva){
        Map params = [parte: dettaglio.parte, natura: dettaglio.natura, flagDefault:Boolean.TRUE,
                      categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice]
        Integer richiamo = null
        if (FormulaUtils.addFormulaScioglimento(chiave, tipoOperazione, dettaglio)) {
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
                case FormulaUtils.FORMULA_RICHIEDENTI_FISSA:
                    if (datiProvenienza.avvocato2?.trim() || datiProvenienza.avvocato1?.trim()){
                        params.put("avvocati", ETipoSiNo.SI.name())
                    } else {
                        params.put("avvocati", ETipoSiNo.NO.name())
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoRichiedentiFisso())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRichiedentiFisso()
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
                    params.put("codiceMinuta", dettaglio.tipoAttoDomain?.codiceMinuta)
                    richiamo = FormulaUtils.getRichiamoTestoLibero()
                    break
                case FormulaUtils.FORMULA_FIRMA:
                    if (datiProvenienza.avvocato2?.trim() || datiProvenienza.avvocato1?.trim()){
                        params.put("avvocati", ETipoSiNo.SI.name())
                    } else {
                        params.put("avvocati", ETipoSiNo.NO.name())
                    }
                    params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                    params.put("progressivo", FormulaUtils.getProgressivoFirma())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoFirma()
                    break
            }
        }
        if (tipoOperazione.isUpdate() && (richiamo != null) ){
            log.info("Tento recupero ${chiave.toUpperCase()} per il record con id ${dettaglio.id}")
            List<Map<String, Object>> formule = gsdService.listFormuleScioglimento(richiamo, params)
            creaFormulaDefault(chiave, richiamo, params)
            aggiornaFormulaFrammento(chiave, formule, salva, Boolean.FALSE)
        }
    }

    void searchFormuleFrammento(String chiave) {
        //FIXME: DEVO PASSARE LA CAT SEMPRE?
        Map params = [parte: dettaglio.parte, natura: dettaglio.natura, flagDb:Boolean.TRUE, divorzio: Boolean.TRUE,
                      categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice]
        Integer richiamo = null
        if (FormulaUtils.addFormulaScioglimento(chiave, tipoOperazione, dettaglio)) {
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
        return [ETipoFormulaAnnotazioneDaAtto.NAS_1, ETipoFormulaAnnotazioneDaAtto.NAS_2, ETipoFormulaAnnotazioneDaAtto.MAT]
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
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_campi_obbligatori_contraenti")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    int recuperaEstremiMatrimonioDaAttoDiMatrimonio(){
        IEstremiAttoMatrimonioDomain d = getEstremiAttoMatrimonioDomain()
        if ( (d.getAttoAttoMatrimonio() == null) && ( d.getParteAttoMatrimonio() == null ) && (d.getAnnoAttoMatrimonio() == null) && ( (d.getDescrizioneComuneAttoMatrimonio()?:"") == "") ){
            CivUnioneCivile mat = civUnioneCivileService.getXDatiAnagraficiSposi(dettaglio.cognome1, dettaglio.nome1, dettaglio.dataNascita1,
                    dettaglio.cognome2, dettaglio.nome2, dettaglio.dataNascita2)
            if (mat){
                ArcComune comune = gsdService.getComuneCliente()
                CivDatiProvenienzaAtto dpaMat = civUnioneCivileService.getDatiProvenienzaByUkAtto(mat.idAtto)
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
            civScioglimentoService.delete(dettaglio)
        }
    }

    @Command void onSelectDichiarante(){
        if (dettaglio.isUfficialeAltro() && datiProvenienza?.isMancataConfermaAccordo(dettaglio.tipoAttoEnum)){
            // In caso di mancata conferma valorizzo la lista del dichiarante per retrocompatibilità
            // ma la disabilito e attivo quella del comparente
            listaComparente = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                        getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A1),
                                        getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                        getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A2),
                                        getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
        } else {
            switch (datiProvenienza.tipoDichiarante) {
                case ETipoDichiaranteUnioneCivileScioglimento.C1.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A1),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.CI)]
                    break
                case ETipoDichiaranteUnioneCivileScioglimento.C2.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A2),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.CI)]
                    break
                case ETipoDichiaranteUnioneCivileScioglimento.CI.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.CI),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2A1),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2A2),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2A1A2)]
                    break
                case ETipoDichiaranteUnioneCivileScioglimento.C1A2.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A2),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A1A2)]
                    break
                case ETipoDichiaranteUnioneCivileScioglimento.C2A1.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A1),
                                                getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A2A1)]
                    break
                case ETipoDichiaranteUnioneCivileScioglimento.A1A2.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1A2)]
                    break
            }
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
        switch (datiProvenienza.tipoComparente) {
            case ETipoDichiaranteUnioneCivileScioglimento.CI.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.CI),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C1C2A1.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.CI),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C1C2A2.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.CI),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C1A2.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C1A1A2.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A1A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C2A1.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C2A2A1.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A2A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.A1A2.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C1C2A1A2.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2A1A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1C2A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.CI),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C1.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C1A1.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1A1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C1),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C2.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.C2A2.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2A2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.C2),
                                            getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
            case ETipoDichiaranteUnioneCivileScioglimento.NE.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteUnioneCivileScioglimento.NE)]
                break
        }
        if (datiProvenienza?.tipoFirmatario){
            Boolean exists = listaFirmatario*.get("value").contains(datiProvenienza.tipoFirmatario)
            if (!(exists)){
                datiProvenienza.tipoFirmatario = null
            }
        }
        refreshUi()
    }

    @Command void onSelectTipoDivorzioAltro(){
        caricaListaDichiarante()
        onSelectDichiarante()
        refreshUi()
    }

    void storicizzaAtto(Long pkAtto) {
        civScioglimentoService.storicizza(pkAtto)
    }

}