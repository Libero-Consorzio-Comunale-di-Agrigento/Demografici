package restrict.statocivile.cittadinanza

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.IEstremiAttoMatrimonioDomain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggettiDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeBaseDomain
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.statocivile.AttoSoggettiDettaglioParentViewModel
import restrict.statocivile.IRowMotivoRichiesta

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class CittadinanzaDettaglioParentViewModel extends AttoSoggettiDettaglioParentViewModel implements IRowMotivoRichiesta {

    private static final String MOTIVO_RICHIESTA_FIELD = 'motivoCittadinanza'
    CivCittadinanza dettaglio

    final List<ETipoMargineLaterale> listaMargineLaterale = Arrays.asList(ETipoMargineLaterale.values())

    // Da gestire solo per gli atti in inserimento e non per i consolidati/pregressi
    List<CivFormulaAnnotazione> listaAnnotazioniNascita = []
    List<Map<String, String>> listaStatoCivile = []

    List<Map> listaDichiarante = []
    List<Map> listaComparente = []
    List<Map> listaFirmatario = []

    final List<ETipoDocumentoRiconoscimento> listaDocumentoRiconoscimento = [null] + Arrays.asList(ETipoDocumentoRiconoscimento.values())
    final List<ETipoEnteEmittente> listaEnteEmissioneDocumento = ETipoEnteEmittente.values().toList()

    final List<ETempisticaAssunzionePubblicoImpiego> listaTempisticaAssunzione = [null] + Arrays.asList(ETempisticaAssunzionePubblicoImpiego.values())

    final List<EGradoParentela> listaGradoParentela = [null] + Arrays.asList(EGradoParentela.values())

    final List<ETipoRiconoscimentoCittadinanza> listaTipoRiconoscimento = [null] + Arrays.asList(ETipoRiconoscimentoCittadinanza.values())

    List<CivCategoriaTipoRichiesta> listaTipoRichiesta = []

    List<ETipoTrasmissioneCittadinanza> listaTipoTrasmissioneCittadinanza = []

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivCittadinanzaService civCittadinanzaService

    @WireVariable
    private CivCategoriaTipoRichiestaService civCategoriaTipoRichiestaService

    void doInit(Window w, Long id, CivTipoAtto tipoAttoDomain) {
        self = w

        initMinuscole(ETipoAtto.CIT)

        List<Map> eList = []
        eList.addAll(CivCittadinanza.etichetteDomain)
        eList.addAll([Etichette.getEtichetta("Imprecisato"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Data_Redazione_Atto_Originale"), Etichette.getEtichetta("Motivo_richiesta"),
                      Etichette.getEtichetta("Recupero_da_giuramento"), Etichette.getEtichetta("Recupero_da_richiesta"),
                      Etichette.getEtichetta("Altri_Dati"), Etichette.getEtichetta("Cambio_cognome_nome"), Etichette.getEtichetta("Vecchio_cognome"),
                      Etichette.getEtichetta("Indirizzo_posta_autorita"), Etichette.getEtichetta("Generalita_ascendente"), Etichette.getEtichetta("Generalita_intestatario_vecchie"),
                      Etichette.getEtichetta("Estremi_Atto_Riconoscimento_Materno"), Etichette.getEtichetta("Estremi_Atto_Riconoscimento_Paterno"),
                      Etichette.getEtichetta("Estremi_Collegato"), Etichette.getEtichetta("Estremi_Atto_collegato"),
                      Etichette.getEtichetta("Decreto_Attestazione"), Etichette.getEtichetta("Dati_Decreto_Attestazione"),
                      Etichette.getEtichetta("Genitore_cittadinanza"), Etichette.getEtichetta("Comune_Atto"), Etichette.getEtichetta("Annotazione")])

        eList.addAll(CivDatiProvenienzaAtto.etichetteDomain)
        eList.addAll(CivMargine.etichetteDomain)
        eList.addAll(CivMotivoRichiesta.etichetteDomain)

        // Aggiungo titoli sezioni
        eList.addAll([Etichette.getEtichetta("SEZIONE_INFORMAZIONI_ATTO"), Etichette.getEtichetta("SEZIONE_DATI_INTESTATARIO"), Etichette.getEtichetta("SEZIONE_DATI_ATTO"),
                      Etichette.getEtichetta("SEZIONE_COMPOSIZIONE"), Etichette.getEtichetta("SEZIONE_REDAZIONE"), Etichette.getEtichetta("SEZIONE_ANNOTAZIONI_DA_ATTO")])

        // Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Ask_Gestione_Minorenni")])

        // Aggiungo etichette natura atto
        listaNatura = NaturaUtils.getValoriCittadinanza()
        eList.addAll(listaNatura*.etichettaDesc)

        // Aggiungo etichette sesso
        listaSesso = [null] + ESesso.values().toList()
        eList.addAll(ESesso.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo dichiarante
        eList.addAll((Arrays.asList(ETipoDichiaranteCittadinanza.values()))*.etichettaDesc)

        // Aggiungo etichette margine laterale
        eList.addAll(Arrays.asList(ETipoMargineLaterale.values())*.etichettaDesc)

        // Aggiungo etichette tempistica assunzione
        eList.addAll((Arrays.asList(ETempisticaAssunzionePubblicoImpiego.values()))*.etichettaDesc)

        // Aggiungo etichette grado parentela
        eList.addAll((Arrays.asList(EGradoParentela.values()))*.etichettaDesc)

        // Aggiungo etichette ente emittente
        eList.addAll((Arrays.asList(ETipoEnteEmittente.values()))*.etichettaDesc)

        // Aggiungo etichette documento di riconoscimento
        eList.addAll((Arrays.asList(ETipoDocumentoRiconoscimento.values()))*.etichettaDesc)

        // Aggiungo etichette riconoscimento cittadinanza
        eList.addAll((Arrays.asList(ETipoRiconoscimentoCittadinanza.values()))*.etichettaDesc)

        // Aggiungo etichette tipo richiesta cittadinanza
        eList.addAll((Arrays.asList(ETipoRichiesta.values()))*.etichettaDesc)

        eList.addAll((Arrays.asList(ETipoTrasmissioneCittadinanza.values()))*.etichettaDesc)

        doInitAllAtti(eList, false)

        msgTitle = getEtichetta(Etichette.getEtichetta("Atto_Cittadinanza"))
        tipoAttoLabel = getEtichettaEnum(ETipoAtto.CIT)

        caricaListaDichiarante()

        listaComparente = []

        listaFirmatario = []

        resize()

        if (id){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoDomain:tipoAttoDomain])
        }
    }

    protected void caricaListaDichiarante(){
        listaDichiarante = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.IN),
                                     getDCFItem(ETipoDichiaranteCittadinanza.DE),
                                     getDCFItem(ETipoDichiaranteCittadinanza.NE)]
    }

    void caricaListaStatoCivile(){
        listaStatoCivile = [null]
        /* Per il momento non gestiamo lo stato civile; se dovesse servire scommentiamo
        if (dettaglio.sesso){
            listaStatoCivile.addAll(anaStatoCivileService.listAllBySesso(dettaglio.sesso))
        }
        */
        BindUtils.postNotifyChange(null, null, this, "listaStatoCivile")
    }

    void caricaListaTrasmissioneCittadinanza(){
        if (dettaglio.motivoCittadinanza?.flagMinore){
            if (dettaglio.motivoCittadinanza?.flagRiconoscimento){
                listaTipoTrasmissioneCittadinanza = [null] + [ETipoTrasmissioneCittadinanza.MD] + [ETipoTrasmissioneCittadinanza.PD]
            } else {
                listaTipoTrasmissioneCittadinanza = [null] + Arrays.asList(ETipoTrasmissioneCittadinanza.values())
            }
        }
    }

    // -------------------- IRowMotivoRichiesta - INIZIO --------------------

    @Override
    void caricaListaTipoRichiesta() {
        listaTipoRichiesta = civCategoriaTipoRichiestaService.listAllByCivCategoriaTipoAtto(atto.tipoAttoDomain?.categoriaDomain)
    }

    @Override
    @Command
    void onSelectTipoRichiesta() {
        if(dettaglio.isTrascrizione()){
            svuotaCampiDatiDichiarante()
        }

        refreshUi()
    }

    private void svuotaCampiDatiDichiarante() {
        datiProvenienza.tipoDichiarante = null
        datiProvenienza.tipoComparente = null
        datiProvenienza.tipoFirmatario = null
        datiProvenienza.comprensioneDichiarante = null
        datiProvenienza.motivoImpedimentoDichiarante = null
    }

    @Override
    @Command
    void onCaricaMotiviRichiesta() {
        CivCategoriaTipoAtto categoria = dettaglio.tipoAttoDomain?.categoriaDomain
        if (categoria) {
            Window w = (Window) Executions.createComponents("/restrict/statocivile/cittadinanza/motivoCittadinanzaSelect.zul", self, [categoria: categoria, tipoRichiesta: dettaglio.tipoRichiesta])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data instanceof CivMotivoRichiesta){
                    dettaglio.motivoCittadinanza = (CivMotivoRichiesta)event.data
                    checkSoggettoCollegato()
                    caricaListaTrasmissioneCittadinanza()
                    refreshUi()
                }
            })
            w.doModal()
        }
    }

    @Override
    String getMotivoRichiestaField() {
        if (!dettaglio.hasProperty(MOTIVO_RICHIESTA_FIELD)) {
            throw new RuntimeException("Motivo richiesta non presente per il campo ${MOTIVO_RICHIESTA_FIELD}")
        }
        return MOTIVO_RICHIESTA_FIELD
    }

    // -------------------- IRowMotivoRichiesta - FINE --------------------

    @Command void onSelectRiconoscimento(){
        checkSoggettoCollegato()
    }

    @Command void onSelectTipoTrasmissioneCittadinanza(){
        checkSoggettoCollegato()
    }

    void checkSoggettoCollegato(){
        // Ascendente
        if (dettaglio.motivoCittadinanza?.flagAscendente && (getAscendente() == null)){
            CivSoggettoCollegato sc = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.AS)
            listaSoggettiCollegati.add(sc)
        }
        // Riconoscimento da atto o sentenza
        if (dettaglio.motivoCittadinanza?.flagEstremiRiconoscimento &&
                [ETipoRiconoscimentoCittadinanza.PD, ETipoRiconoscimentoCittadinanza.SP].contains(dettaglio.tipoRiconoscimento) &&
                (getSoggettoCollegatoPadre() == null)){
            CivSoggettoCollegato scPadre = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.PD)
            listaSoggettiCollegati.add(scPadre)
        }
        if (dettaglio.motivoCittadinanza?.flagEstremiRiconoscimento &&
                [ETipoRiconoscimentoCittadinanza.MD, ETipoRiconoscimentoCittadinanza.SM].contains(dettaglio.tipoRiconoscimento) &&
                (getSoggettoCollegatoMadre() == null)){
            CivSoggettoCollegato scMadre = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.MD)
            listaSoggettiCollegati.add(scMadre)
        }
        // Minore (anche in caso di riconoscimento)
        if (dettaglio.motivoCittadinanza?.flagMinore &&
                [ETipoTrasmissioneCittadinanza.PD, ETipoTrasmissioneCittadinanza.EN].contains(dettaglio.tipoTrasmissioneCittadinanza) &&
                (getSoggettoCollegatoPadre() == null)){
            CivSoggettoCollegato scPadre = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.PD)
            listaSoggettiCollegati.add(scPadre)
        }
        if (dettaglio.motivoCittadinanza?.flagMinore &&
                [ETipoTrasmissioneCittadinanza.MD, ETipoTrasmissioneCittadinanza.EN].contains(dettaglio.tipoTrasmissioneCittadinanza) &&
                (getSoggettoCollegatoMadre() == null)){
            CivSoggettoCollegato scMadre = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.MD)
            listaSoggettiCollegati.add(scMadre)
        }
        // Genitori
        if ( dettaglio.motivoCittadinanza?.flagPadre && (getSoggettoCollegatoPadre() == null) ){
            CivSoggettoCollegato scPadre = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.PD)
            listaSoggettiCollegati.add(scPadre)
        }
        if (dettaglio.motivoCittadinanza?.flagMadre && (getSoggettoCollegatoMadre() == null) ){
            CivSoggettoCollegato scMadre = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.MD)
            listaSoggettiCollegati.add(scMadre)
        }
        // Interprete
        if (datiProvenienza?.isComparenteInterprete() && (getInterprete() == null)) {
            CivSoggettoCollegato scInterprete = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.IT)
            listaSoggettiCollegati.add(scInterprete)
        }
        // Cambio generalitò
        if (dettaglio.motivoCittadinanza?.flagCambioGeneralita && (getIntestatarioVecchioGeneralita() == null)){
            CivSoggettoCollegato scIntestatarioVecchieGeneralita = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.CG, cambioGeneralita: ETipoSiNo.NO)
            listaSoggettiCollegati.add(scIntestatarioVecchieGeneralita)
        }
        refreshUi()
    }

    List<String> getChiaviFormule(){
        return [FormulaUtils.FORMULA_TESTO_LIBERO]
    }

    void searchFormulaDefault(String chiave, Boolean salva){
        Map params = [natura: dettaglio.natura, flagDefault:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaCittadinanza(chiave, tipoOperazione, dettaglio)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTO_LIBERO:
                    params.put("codiceMinuta", dettaglio.tipoAttoDomain?.codiceMinuta)
                    params.put("categoria", dettaglio.tipoAttoDomain?.categoriaDomain?.codice)
                    richiamo = FormulaUtils.getRichiamoTestoLibero()
                    break
            }
        }
        if (tipoOperazione.isUpdate() && (richiamo != null) ){
            log.info("Tento recupero ${chiave.toUpperCase()} per il record con id ${dettaglio.id}")
            List<Map<String, Object>> formule = gsdService.listFormuleCittadinanza(richiamo, params)
            creaFormulaDefault(chiave, richiamo, params)
            aggiornaFormulaFrammento(chiave, formule, salva, Boolean.FALSE)
        }
    }

    void searchFormuleFrammento(String chiave) {
        Map params = [natura: dettaglio.natura, flagDb:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaCittadinanza(chiave, tipoOperazione, dettaglio)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTO_LIBERO:
                    params.put("categoria", dettaglio.tipoAttoDomain?.categoriaDomain?.codice)
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoTestoLiberoGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    params.put("tipoRichiesta", dettaglio.tipoRichiesta?.id)
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
        return ( ( (dettaglio.natura == ENaturaAtto.A) || (dettaglio.natura == ENaturaAtto.P) ) && dettaglio.isCodRec3() )
    }

    Boolean isCaricamentoAnnotazioniAbilitato(){
        return ( tipoOperazione.isUpdate() && isCaricamentoFormuleAnnotazioneAbilitato() )
    }

    @Override
    protected void caricaDatiSoggetto1(AnaAnagrafeBaseDomain ana){
        super.caricaDatiSoggetto1(ana)

        onSelectSesso(null)
    }

    @Command void onSelectSesso(@BindingParam("campoAnagrafe") String campoAnagrafe) {
        caricaListaStatoCivile()
        if(campoAnagrafe){
            onAggiornaAna(campoAnagrafe)
        }

    }

    @Command void onChangeDataGiuramento() {
        dettaglio.dataDecorrenza = DataUtils.addDays(dettaglio.dataGiuramento, 1)
        refreshDettaglio()
    }

    void eliminaAtto(){
        if (deleteRecordEnabled && userModifyEnabled) {
            civCittadinanzaService.delete(dettaglio)
        }
    }

    // invocato dalla sezione dic-com-firm
    @Command void onSelectDichiarante(){
        if (dettaglio.isDicCompFirmCitVisibile()) {
            switch (datiProvenienza.tipoDichiarante) {
                case ETipoDichiaranteCittadinanza.NE.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.NE)]
                    break
                case ETipoDichiaranteCittadinanza.IN.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.IN),
                                                getDCFItem(ETipoDichiaranteCittadinanza.INIT),
                                                getDCFItem(ETipoDichiaranteCittadinanza.NE)]
                    break
                case ETipoDichiaranteCittadinanza.DE.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.DE),
                                                getDCFItem(ETipoDichiaranteCittadinanza.DEIN),
                                                getDCFItem(ETipoDichiaranteCittadinanza.DEIT),
                                                getDCFItem(ETipoDichiaranteCittadinanza.DEINIT),
                                                getDCFItem(ETipoDichiaranteCittadinanza.NE)]
                    break
            }
            if (datiProvenienza?.tipoComparente) {
                Boolean exists = listaComparente*.get("value").contains(datiProvenienza.tipoComparente)
                if (!(exists)) {
                    datiProvenienza.tipoComparente = null
                }
            }
            onSelectComparente()
        } else {
            checkSoggettoCollegato()
        }
    }

    // invocato dalla sezione dic-com-firm
    @Command void onSelectComparente(){
        switch (datiProvenienza.tipoComparente){
            case ETipoDichiaranteCittadinanza.NE.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.NE)]
                break
            case ETipoDichiaranteCittadinanza.IN.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.IN),
                                            getDCFItem(ETipoDichiaranteCittadinanza.NE)]
                break
            case ETipoDichiaranteCittadinanza.DE.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.DE),
                                            getDCFItem(ETipoDichiaranteCittadinanza.NE)]
                break
            case ETipoDichiaranteCittadinanza.INIT.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.INIT),
                                            getDCFItem(ETipoDichiaranteCittadinanza.IN),
                                            getDCFItem(ETipoDichiaranteCittadinanza.IT),
                                            getDCFItem(ETipoDichiaranteCittadinanza.NE)]
                break
            case ETipoDichiaranteCittadinanza.DEIN.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.DEIN),
                                            getDCFItem(ETipoDichiaranteCittadinanza.DE),
                                            getDCFItem(ETipoDichiaranteCittadinanza.IN),
                                            getDCFItem(ETipoDichiaranteCittadinanza.NE)]
                break
            case ETipoDichiaranteCittadinanza.DEIT.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.DEIT),
                                            getDCFItem(ETipoDichiaranteCittadinanza.DE),
                                            getDCFItem(ETipoDichiaranteCittadinanza.IT),
                                            getDCFItem(ETipoDichiaranteCittadinanza.NE)]
                break
            case ETipoDichiaranteCittadinanza.DEINIT.name():
                listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteCittadinanza.DEINIT),
                                            getDCFItem(ETipoDichiaranteCittadinanza.INIT),
                                            getDCFItem(ETipoDichiaranteCittadinanza.DEIN),
                                            getDCFItem(ETipoDichiaranteCittadinanza.DEIT),
                                            getDCFItem(ETipoDichiaranteCittadinanza.IN),
                                            getDCFItem(ETipoDichiaranteCittadinanza.DE),
                                            getDCFItem(ETipoDichiaranteCittadinanza.IT),
                                            getDCFItem(ETipoDichiaranteCittadinanza.NE)]
                break
        }
        if (datiProvenienza?.tipoFirmatario){
            Boolean exists = listaFirmatario*.get("value").contains(datiProvenienza.tipoFirmatario)
            if (!(exists)){
                datiProvenienza.tipoFirmatario = null
            }
        }
        checkSoggettoCollegato()
        //refreshUi()
    }

    void storicizzaAtto(Long pkAtto) {
        civCittadinanzaService.storicizza(pkAtto)
    }

}