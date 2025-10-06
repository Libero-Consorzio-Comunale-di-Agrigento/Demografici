package restrict.certificazione.emissione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.ICertificabile
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.certificazione.embed.Richiedente
import it.finmatica.de4gsdzk.certificazione.emissione.*
import it.finmatica.de4gsdzk.certificazione.error.UtenteNonTerminalistaRuntimeException
import it.finmatica.de4gsdzk.certificazione.generazione.*
import it.finmatica.de4gsdzk.certificazione.generazione.anpr.AnprGenerazioneCertificatoParams
import it.finmatica.de4gsdzk.certificazione.generazione.anpr.AnprGenerazioneCertificatoRuntimeException
import it.finmatica.de4gsdzk.certificazione.generazione.ansc.AnscGenerazioneCertificatoParams
import it.finmatica.de4gsdzk.certificazione.generazione.ansc.AnscGenerazioneCertificatoRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreModelloNonTrovatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivMessaggio
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.zkutils.ETipoDocumentoAnagrafeFiltro
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.TraitComune
import restrict.statocivile.DizionarioDettaglioViewModel

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class EmissioneCertificatoViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi, TraitComune {
    final List<ESesso> listaSesso = [null] + ESesso.values().toList()
    final List<ETipoSiNo> listaSiNo = [ETipoSiNo.SI, ETipoSiNo.NO]
    final List<ENaturaDocumento> listaNaturaDocumentoAnagrafico = [ENaturaDocumento.O, ENaturaDocumento.D]
    final ETipoDocumentoAnagrafeFiltro tipoDocumentoAnagrafeFiltro = ETipoDocumentoAnagrafeFiltro.RICONOSCIMENTO
    List<AnaNazionalita> listaNazionalita = []
    List<CerTipoPagamento> listaTipoPagamento = []
    List<CerTipoRichiedente> listaTipoRichiedente = []

    @Delegate
    EmissioneCertificatoViewState emissioneCertificatoState
    CivAttoBaseDomain atto
    Boolean ricercaSoggettoInANPROn
    EmissioneCertificatoCache emissioneCertificatoCache

    @WireVariable
    private CerCertificatoEmessoService cerCertificatoEmessoService

    @WireVariable
    private CerCategoriaTipoCertificatoService cerCategoriaTipoCertificatoService

    @WireVariable
    private CerAnagrafeFiltroService cerAnagrafeFiltroService

    @WireVariable
    private CerTerminalistaService cerTerminalistaService

    @WireVariable
    private CerFondoCassaTerminalistaService cerFondoCassaTerminalistaService

    @WireVariable
    private AnaNazionalitaService anaNazionalitaService

    @WireVariable
    private AnaMessaggioService anaMessaggioService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private CerTariffaDirittoService cerTariffaDirittoService

    @WireVariable
    private CerTipoPagamentoService cerTipoPagamentoService

    @WireVariable
    private EmissioneCertificatoService emissioneCertificatoService

    @WireVariable
    private EmissioneCertificatoStatoCivileService emissioneCertificatoStatoCivileService

    @WireVariable
    private TipoGenerazioneCertificatoService tipoGenerazioneCertificatoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map<String, String>> eList = [Etichette.Emissione_Certificato, Etichette.Motivo,
                                           Etichette.SEZIONE_BENEFICIARIO, Etichette.SEZIONE_RICHIEDENTE, Etichette.SEZIONE_DATI_CERTIFICATO,
                                           Etichette.Tipo_Emissione, Etichette.Tipo_Certificato, Etichette.Al, Etichette.Modalita_rilascio, Etichette.Firma_Emissione]
        eList.addAll([Etichette.Altri_Dati])
        eList.addAll(GsdAnagrafeBaseDomain.etichetteDomain)
        eList.addAll(CerCertificatoEmesso.etichetteDomain)
        eList.addAll(CerCategoriaTipoCertificato.etichetteDomain)
        eList.addAll(CerTerminalista.etichetteDomain)
        eList.addAll(CerTipoCertificato.etichetteDomain)

        eList.addAll(ESesso.values()*.getEtichettaDesc())
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())
        eList.addAll(EDiritto.values()*.getEtichettaDesc())
        eList.addAll(Etichette.Messaggi)
        eList.addAll([EtichetteMessaggi.Errore_salvataggio_file_documentale, EtichetteMessaggi.Errore_salvataggio_file_documentale_individuo, EtichetteMessaggi.Errore_modello_testo_non_trovato, EtichetteMessaggi.Ask_Conferma_Salvataggio_Documento,
                      EtichetteMessaggi.Ask_ANPR_generazione_cer_forzata, EtichetteMessaggi.Errore_ANPR_generazione_cer, EtichetteMessaggi.Errore_ANSC_generazione_cer, EtichetteMessaggi.Errore_GTE_generazione_cer,
                      EtichetteMessaggi.Errore_Utente_non_terminalista, EtichetteMessaggi.Compilare_campi_obbligatori_sezione, EtichetteMessaggi.Errore_Ana_filtro_non_trovato,
                      EtichetteMessaggi.Ask_Archiviazione_Documento_Individuo, EtichetteMessaggi.Info_Archiviazione_Documento_Individuo])

        // Aggiungo etichette per documento anagrafico
        eList.addAll([Etichette.Documento_Individuo, Etichette.Numera])
        eList.addAll(AnaTipoDocumento.etichetteDomain)
        eList.addAll(AnaDocumento.etichetteDomain)
        eList.addAll(ENaturaDocumento.values()*.getEtichettaDesc())

        // Aggiungo etichette per tipi generazione esterne
        eList.addAll(ETipoGenerazioneCertificato.values().findAll { it.isGenerazioneEsterna() }*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Emissione_Certificato)
        formLabel = msgTitle?.toUpperCase()

        resize()

        ricercaSoggettoInANPROn = arcParametroService.isRicercaSoggettoInANPRAttiva()

        emissioneCertificatoCache = new EmissioneCertificatoCache()

        caricaListaTipoRichiedente()

        caricaListaTipiPagamento()

        caricaListaNazionalita()

        creaEmissione()
    }

    @Command
    void onInserisci() {
        Messagebox.show(getEtichetta(EtichetteMessaggi.Ask_Modifiche_In_Sospeso), getEtichetta(Etichette.Chiusura), Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_YES.equals(e.getName())) {
                            creaEmissione()
                            refreshUi()
                        }
                    }
                }
        )
    }

    @Command
    void onCheckTipoRichiedente() {
        if (tipoRichiedente.isAltroRichiedente()) {
            richiedenteState.richiedente = new Richiedente()
        } else {
            richiedenteState.richiedente = null
        }
        updateRichiedenteFieldsMandatory()
        refreshUi()
    }

    void caricaListaTipoRichiedente() {
        listaTipoRichiedente = emissioneCertificatoService.listAllTipoRichiedenteOptions()
    }

    private void updateRichiedenteFieldsMandatory() {
        ETipoGenerazioneCertificato tipoGenerazioneCertificato = null
        if (forceGenerazioneGte != null && tipoCertificato != null) {
            tipoGenerazioneCertificato = tipoGenerazioneCertificatoService.get(forceGenerazioneGte, tipoCertificato)
        }

        richiedenteState.documentoMandatory = emissioneCertificatoService.isDocumentoRichiedenteMandatory(tipoGenerazioneCertificato, richiedenteState?.anagrafe)
        richiedenteState.datiAnagraficiMandatory = emissioneCertificatoService.isDatiAnagraficiAggiuntiviRichiedenteMandatory(tipoGenerazioneCertificato)

        BindUtils.postNotifyChange(null, null, this, "richiedenteState")
    }

    private void updateDataStoricoMandatory() {
        dataStoricoMandatory = emissioneCertificatoService.isDataStoricoMandatory(tipoCertificato)
        BindUtils.postNotifyChange(null, null, this, "dataStoricoMandatory")
    }

    void caricaListaNazionalita(){
        listaNazionalita = [null]
        List<AnaNazionalita> l = anaNazionalitaService.listAll()
        if (l.size()>0){
            listaNazionalita.addAll(l)
        }
    }

    void caricaListaTipiPagamento(){
        listaTipoPagamento = [null] + cerTipoPagamentoService.listAll()
    }

    void caricaListaCategorie() {
        if (beneficiarioState.anagrafeFiltroList.isEmpty()) {
            return
        }

        listaCategoriaTipoCertificato = cerCategoriaTipoCertificatoService.listAllByAnagrafeFiltroList(beneficiarioState.anagrafeFiltroList)

        if (listaCategoriaTipoCertificato.size() == 1) {
            categoriaTipoCertificatoSelezionata = listaCategoriaTipoCertificato.get(0)
        }
    }

    @Override
    Object getDettaglio() {
        throw new UnsupportedOperationException('Impossibile caricare un certificato emesso tramite la maschera di emissione')
    }

    @Override
    void caricaDettaglio(def id) {
        throw new UnsupportedOperationException('Impossibile caricare un certificato emesso tramite la maschera di emissione')
    }

    @Override
    void creaDettaglio(Map params) {
        throw new UnsupportedOperationException('Impossibile caricare un certificato emesso tramite la maschera di emissione')
    }

    void creaEmissione() {
        emissioneCertificatoState = new EmissioneCertificatoViewState()
        diritti = new DirittiViewState()
        tipoRichiedente = emissioneCertificatoService.getDefaultTipoRichiedenteOption()
        richiedenteState = new RichiedenteViewState()
        beneficiarioState = new BeneficiarioViewState()
        beneficiarioState.addListener(new IBeneficiarioCertificatoListener() {
            @Override
            void onChange(EBeneficiarioCertificatoEvent event) {
                if (event == EBeneficiarioCertificatoEvent.PROPERTY_CHANGED) {
                    resetCascade()
                    refreshUi()
                }
                if (event == EBeneficiarioCertificatoEvent.LOAD) {
                    resetCascade()

                    if (beneficiarioState.hasRequiredDataForAnagrafeFiltroSearch()) {
                        List<CerAnagrafeFiltro> l = cerAnagrafeFiltroService.listAllByAnagrafe(beneficiarioState.anagrafe)
                        if (l.isEmpty()) {
                            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(EtichetteMessaggi.Errore_Ana_filtro_non_trovato))
                        }
                        beneficiarioState.loadAnagrafeFiltroList(l)
                        caricaListaCategorie()
                    }

                    if (beneficiarioState.hasRequiredDataForMessaggiSearch()) {
                        beneficiarioState.loadMessaggioList(anaMessaggioService.listAllForCertificazioneByMatricola(beneficiarioState.matricola))
                        if (!beneficiarioState.messaggioList.isEmpty()) {
                            openMessaggiIndividuo()
                        }
                    }

                    refreshUi()
                }
            }
        })

        try {
            this.terminalista = cerTerminalistaService.getTerminalistaUtente()
            setTerminalistaInStampa(this.terminalista)

            if (terminalista.flagFondoCassa && !cerFondoCassaTerminalistaService.existsByTerminalistaAndData(terminalista, DataUtils.getDataCorrente())) {
                openFondoCassa()
            }
        } catch (UtenteNonTerminalistaRuntimeException ex) {
            log.error(ex.message, ex)
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(ex.etichetta) ?: getEtichetta(EtichetteMessaggi.Errore_Utente_non_terminalista))
            onChiudi()
        }
    }

    @Command void onCancellaCampoBeneficiario(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(beneficiarioState, p)
    }

    @Command void onCancellaCampoRichiededente(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(richiedenteState.richiedente, p)
    }

    @Command void onCancellaCampoCertificato(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(this, p)
    }

    @Command
    void onCancellaCampoDocumentoAnagrafico(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(documentoAnagrafico, p)
    }


    @Command
    void onSelectTipoDocumento(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.target?.selectedItem instanceof AnaTipoDocumento) {
            richiedenteState.richiedente.tipoDocumento = (AnaTipoDocumento) event.target.selectedItem
        } else {
            richiedenteState.richiedente.tipoDocumento = null
        }
        refreshUi()
    }

    @Command
    void onSelectCategoriaTipoCertificato(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        refreshUi()
    }

    @Command
    void onSelectTipoCertificato(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTipoCertificato) {
            tipoCertificato = (CerTipoCertificato) event.getData()
            documentoAnagraficoSource = emissioneCertificatoService.getDocumentoAnagraficoSource(tipoCertificato)
            documentoAnagrafico = emissioneCertificatoService.getDocumentoAnagrafico(beneficiarioState.matricola, tipoCertificato.tipoDocumentoAnagrafe, documentoAnagraficoSource)
        } else {
            tipoCertificato = null
        }

        updateRichiedenteFieldsMandatory()
        updateDataStoricoMandatory()
        refreshUi()
    }

    @Command
    void onSelectTerminalistaInStampa(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTerminalista) {
            CerTerminalista terminalistaInStampa = (CerTerminalista) event.getData()
            setTerminalistaInStampa(terminalistaInStampa)
        } else {
            setTerminalistaInStampa(null)
        }
        refreshUi()
    }

    @Command
    void onChangePreventDefaultTerminalistaInStampa(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof String) {
            setCognomeNomeTerminalista(event.data as String)
            refreshUi()
        }
    }

    @Command
    void onNumeraDocumentoAnagrafico(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        documentoAnagrafico.numero = emissioneCertificatoService.calculateNumeroDocumentoAnagrafico(tipoCertificato)
        refreshUi()
    }

    @Command void onSelectModalitaRilascio(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerModalitaRilascio) {
            modalitaRilascio = (CerModalitaRilascio) event.getData()
            updateDiritti()
        } else {
            modalitaRilascio = null
        }
        refreshUi()
    }

    @Command
    void onCheckForceGenerazioneGte(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        updateRichiedenteFieldsMandatory()
        updateDataStoricoMandatory()
        refreshUi()
    }

    private void updateDiritti() {
        Map<EDiritto, CerTariffaDiritto> tariffeDirittoTipoCertificato = [:]
        this.tipoCertificato.tipoCertificatoTariffaDirittoList*.tariffaDiritto.each {
            if (tariffeDirittoTipoCertificato.containsKey(it.diritto)) {
                throw new IllegalStateException("TariffaDiritto duplicato per il diritto ${it.diritto} e per tipo certificato ${tipoCertificato.id}")
            }
            tariffeDirittoTipoCertificato.put(it.diritto, it)
        }

        diritti.segreteria.descrizione = tariffeDirittoTipoCertificato[EDiritto.SEGRETERIA]?.descrizione
        diritti.statoCivile.descrizione = tariffeDirittoTipoCertificato[EDiritto.STATO_CIVILE]?.descrizione
        diritti.cartaIdentita.descrizione = tariffeDirittoTipoCertificato[EDiritto.CARTA_IDENTITA]?.descrizione
        diritti.rimborsoStampati.descrizione = tariffeDirittoTipoCertificato[EDiritto.RIMBORSO_STAMPATI]?.descrizione
        diritti.bollo.descrizione = tariffeDirittoTipoCertificato[EDiritto.BOLLO]?.descrizione

        if (modalitaRilascio.esenzioneDiritti == ETipoSiNo.SI) {
            diritti.resetImporto()
            return
        }

        if (modalitaRilascio.isInBollo()) {
            CerTariffaDiritto tariffaBollo = cerTariffaDirittoService.findTariffaDirittoBolloByFasciaTariffaria(modalitaRilascio.fasciaTariffaria)
            diritti.bollo.descrizione = tariffaBollo?.descrizione
            diritti.bollo.importo = tariffaBollo?.importo1

            diritti.segreteria.importo = tariffeDirittoTipoCertificato[EDiritto.SEGRETERIA]?.importo2
            diritti.statoCivile.importo = tariffeDirittoTipoCertificato[EDiritto.STATO_CIVILE]?.importo2
            diritti.cartaIdentita.importo = tariffeDirittoTipoCertificato[EDiritto.CARTA_IDENTITA]?.importo2
            diritti.rimborsoStampati.importo = tariffeDirittoTipoCertificato[EDiritto.RIMBORSO_STAMPATI]?.importo2
            return
        }

        diritti.segreteria.importo = tariffeDirittoTipoCertificato[EDiritto.SEGRETERIA]?.importo1
        diritti.statoCivile.importo = tariffeDirittoTipoCertificato[EDiritto.STATO_CIVILE]?.importo1
        diritti.cartaIdentita.importo = tariffeDirittoTipoCertificato[EDiritto.CARTA_IDENTITA]?.importo1
        diritti.rimborsoStampati.importo = tariffeDirittoTipoCertificato[EDiritto.RIMBORSO_STAMPATI]?.importo1
    }

    @Command
    void onEnableDiritto(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        String d = event?.target?.getAttribute("diritto")
        EDiritto diritto = EDiritto.valueOf(d)
        diritti.switchEditable(diritto)
        refreshUi()
    }

    @Command
    void onSelectDiritto(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        CerTariffaDiritto tariffaDiritto = event?.data as CerTariffaDiritto
        diritti.setImporto(tariffaDiritto.diritto, modalitaRilascio.isInBollo() ? tariffaDiritto.importo2 : tariffaDiritto.importo1)
        refreshUi()
    }

    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        switch (tca) {
            case ETipoComuneAtto.CN_RIC:
                riempiComune(richiedenteState.richiedente.comuneNascita, c)
                break
            case ETipoComuneAtto.CN_BEN:
                riempiComune(beneficiarioState.comuneNascita, c)
                break
        }
    }

    @Command void onCaricaSoggetti(@BindingParam("tipoSoggetto") String tipoSoggetto){
        ETipoSoggetto ts = ETipoSoggetto.valueOf(tipoSoggetto)
        Map params
        switch (ts) {
            case ETipoSoggetto.RICHIEDENTE_CERTIFICATO:
                params = [cognome      : richiedenteState.richiedente.cognome,
                          nome         : richiedenteState.richiedente.nome,
                          sesso        : richiedenteState.richiedente.sesso,
                          dataNascita  : richiedenteState.richiedente.dataNascita,
                          codiceFiscale: richiedenteState.richiedente.codiceFiscale,
                          soloResidenti: Boolean.FALSE,
                          sessoEnabled : Boolean.TRUE]
                break
            case ETipoSoggetto.BENEFICIARIO_CERTIFICATO:
                params = [cognome       : beneficiarioState.cognome,
                          nome          : beneficiarioState.nome,
                          sesso         : beneficiarioState.sesso,
                          dataNascita   : beneficiarioState.dataNascita,
                          codiceFiscale : beneficiarioState.codiceFiscale,
                          soloResidenti : Boolean.FALSE,
                          anagrafeEstesa: Boolean.TRUE,
                          sessoEnabled  : Boolean.TRUE]
                break
        }
        if (params){
            Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data instanceof GsdAnagrafeBaseDomain){
                    GsdAnagrafeBaseDomain ana = (GsdAnagrafeBaseDomain)event.data
                    switch (ts) {
                        case ETipoSoggetto.RICHIEDENTE_CERTIFICATO:
                            richiedenteState.anagrafe = ana
                            richiedenteState.richiedente = emissioneCertificatoService.createRichiedente(ana)
                            updateRichiedenteFieldsMandatory()
                            break
                        case ETipoSoggetto.BENEFICIARIO_CERTIFICATO:
                            beneficiarioState.anagrafe = ana
                            beneficiarioState.beneficiario = emissioneCertificatoService.createBeneficiario(ana)
                            beneficiarioState.setLoaded()
                            break
                    }
                    refreshUi()
                }
            })
            w.doModal()
        }
    }

    @Command void onCancellaAnagrafica(@BindingParam("tipoSoggetto") String tipoSoggetto) {
        ETipoSoggetto ts = ETipoSoggetto.valueOf(tipoSoggetto)
        switch (ts) {
            case ETipoSoggetto.BENEFICIARIO_CERTIFICATO:
                // Resetta per non eliminare i listeners associati al beneficiario
                beneficiarioState.reset()
                resetCascade()
                break
            case ETipoSoggetto.RICHIEDENTE_CERTIFICATO:
                richiedenteState.reset()
                break
        }
        refreshUi()
    }

    @Command void onElaboraCertificato() {
        if (tipoCertificato == null) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(EtichetteMessaggi.Compilare_campi_obbligatori_sezione) + " " + getEtichetta(Etichette.Tipo_Certificato))
            return
        }

        if (dataStoricoMandatory) {
            if (dataStorico == null) {
                MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(EtichetteMessaggi.Compilare_campi_obbligatori_sezione) + " " + getEtichetta(Etichette.Tipo_Certificato))
                return
            }
        }

        if (modalitaRilascio == null) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(EtichetteMessaggi.Compilare_campi_obbligatori_sezione) + " " + getEtichetta(Etichette.Modalita_rilascio))
            return
        }

        if (tipoRichiedente?.id == CerTipoRichiedente.ALTRO_RICHIEDENTE) {
            if (TestoUtils.isVuoto(richiedenteState.richiedente.codiceFiscale) ||
                    TestoUtils.isVuoto(richiedenteState.richiedente.cognome) ||
                    TestoUtils.isVuoto(richiedenteState.richiedente.nome)) {
                MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(EtichetteMessaggi.Compilare_campi_obbligatori_sezione) + " " + getEtichetta(Etichette.Richiedente))
                return
            }
            if (richiedenteState.documentoMandatory &&
                    (richiedenteState.richiedente.tipoDocumento == null ||
                            TestoUtils.isVuoto(richiedenteState.richiedente.numeroDocumento) ||
                            richiedenteState.richiedente.dataRilascioDocumento == null)) {
                MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(EtichetteMessaggi.Compilare_campi_obbligatori_sezione) + " " + getEtichetta(Etichette.Richiedente))
                return
            }
            if (richiedenteState.datiAnagraficiMandatory) {
                if (richiedenteState.richiedente.dataNascita == null ||
                        richiedenteState.richiedente.sesso == null ||
                        richiedenteState.richiedente.comuneNascita.codice == null ||
                        richiedenteState.richiedente.comuneNascita.codiceProvincia == null) {
                    MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(EtichetteMessaggi.Compilare_campi_obbligatori_sezione) + " " + getEtichetta(Etichette.Richiedente))
                    return
                }
            }
        }

        if (documentoAnagrafico != null && TestoUtils.isVuoto(documentoAnagrafico.numero)) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, "Numero documento non specificato.")
            return
        }

        if (emissioneCertificatoService.isEmissioneCertificatoBloccatoDaMessaggiAnagrafeBloccanti(modalitaRilascio, beneficiarioState.messaggioList)) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, "Impossibile emettere il certificato perché il beneficiario ha restituito messaggi bloccanti")
            return
        }

        CerCertificatoEmesso certificatoDaEmettere = emissioneCertificatoService.createCertificatoEmesso(emissioneCertificatoState)
        Boolean shouldAlert = emissioneCertificatoCache.shouldAlert(certificatoDaEmettere)
        if (shouldAlert) {
            Messagebox.show("Attenzione! Certificato già emesso per medesimo beneficiario/richiedente.\nProcedere con ulteriore emissione?", msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    { Event e ->
                        if (Messagebox.ON_OK == e.getName()) {
                            selectAndElaboraCertificato()
                        }
                    })
        } else {
            selectAndElaboraCertificato()
        }
    }

    private void selectAndElaboraCertificato() {
        if (tipoCertificato.isStatoCivile()) {
            List<CivMessaggio> messaggi = []

            Map<String, EventListener> listeners = [:]

            listeners << [(CustomEvents.ON_CER_EMISSIONE_ATTO_SELECT): { event ->
                CivAttoBaseDomain attoSelected = event.data?.attoSelezionato as CivAttoBaseDomain
                Map params = [fetch: [[campo: 'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT]]]
                atto = emissioneCertificatoStatoCivileService.getAtto(attoSelected.tipoAttoEnum, attoSelected.id, params)
                messaggi = emissioneCertificatoStatoCivileService.listMessaggiStatoCivileByAtto(atto)

                if (!messaggi.isEmpty()) {
                    Window popupAvvisi = (Window) Executions.createComponents('/restrict/afc/popupAvvisi.zul', self, [listaMessaggi: messaggi])
                    popupAvvisi.doModal()
                }
            }]

            listeners << [(CustomEvents.ON_CER_EMISSIONE_COMPLETE): { event ->
                if (emissioneCertificatoStatoCivileService.isEmissioneCertificatoBloccatoDaMessaggiStatoCivileBloccanti(modalitaRilascio, messaggi)) {
                    MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, "Impossibile emettere il certificato perché l'atto ha restituito messaggi bloccanti")
                    return
                }
                elaboraCertificato()
            }]

            popupSelectAtto(listeners)

        } else if (tipoCertificato.isAnagrafe()) {

            if (documentoAnagrafico == null) {
                elaboraCertificato()
                return
            }

            if (documentoAnagraficoSource == EDocumentoAnagraficoSource.CREATE_NEW) {
                elaboraCertificato(true)
                return
            }

            if (documentoAnagraficoSource == EDocumentoAnagraficoSource.EXISTING) {
                String msg = String.format(getEtichetta(EtichetteMessaggi.Ask_Archiviazione_Documento_Individuo), documentoAnagrafico.tipoDocumento.id, documentoAnagrafico.numero)
                Messagebox.show(msg, msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION, { Event e ->

                    if (Messagebox.ON_YES == e.getName()) {
                        elaboraCertificato(true)
                        return
                    }

                    if (Messagebox.ON_NO == e.getName()) {
                        elaboraCertificato()
                    }
                })
            }
        }
    }

    private void popupSelectAtto(Map<String, EventListener> listeners) {
        List<ICertificabile> lAtti = emissioneCertificatoStatoCivileService.listAttiByTipoCertificatoAndBeneficiario(tipoCertificato, beneficiarioState)
        if (lAtti.size() == 0) {
            Messagebox.show("Errore in generazione certificato ${tipoCertificato.descrizione}:\n non è stato trovato alcun atto corrispondente ai dati anagrafici inseriti", msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        if (lAtti.size() > 0) {
            String uri = "/restrict/certificazione/emissione/emissioneCertificatoAttoSelect.zul"
            Window popup = (Window) Executions.createComponents(uri, self.parent, [listaAtti: lAtti, forceGenerazioneGte: forceGenerazioneGte, tipoCertificato: tipoCertificato, tipoRichiedente: tipoRichiedente])
            listeners.each { k, v ->
                popup.addEventListener(k, v)
            }
            popup.doModal()
        }
    }

    private void elaboraCertificato(Boolean saveDocumentoAnagrafico = false) {
        ETipoGenerazioneCertificato tipoGenerazione = tipoGenerazioneCertificatoService.get(forceGenerazioneGte, tipoCertificato, atto)
        IGenerazioneCertificatoService generazioneCertificatoService = emissioneCertificatoService.getGenerazioneCertificatoService(tipoGenerazione)

        CerCertificatoEmesso certificato = emissioneCertificatoService.createCertificatoEmesso(emissioneCertificatoState)
        certificato.generazioneEsterna = tipoGenerazione.isGenerazioneEsterna()

        // Effettua una validazione della generabilità del certificato prima di effettuare i salvataggi
        try {
            generazioneCertificatoService.validateGenerazioneCertificato(certificato)
        } catch (Exception ex) {
            log.error("Errore durante la validazione della generazione certificato", ex)

            String msg = calculateErrorMessage(ex as De4gsdzkRuntimeException, certificato)
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, msg)

            return
        }

        // Salvo il documento anagrafico.
        // È necessario che il documento anagrafico sia salvato prima di generare il certificato, altrimenti,
        //  il certificato generato si riferirà ad un documento anagrafico non corretto.
        if (documentoAnagrafico != null && saveDocumentoAnagrafico) {
            emissioneCertificatoService.saveDocumentoAnagrafico(documentoAnagrafico)
        }

        // Salvo il certificato emesso
        // È necessario che il certificato emesso sia salvato prima di generare il certificato, perché
        //  le integrazioni con ANSC e ANPR useranno il record di CERCEM per generare il certificato.
        CerCertificatoEmesso saved = cerCertificatoEmessoService.saveNew(certificato, beneficiarioState.matricola, atto)

        IGenerazioneCertificatoParams params = emissioneCertificatoService.getGenerazioneCertificatoParams(tipoGenerazione)

        if (params instanceof AnprGenerazioneCertificatoParams) {
            ((AnprGenerazioneCertificatoParams) params).flagForzatura = flagForzaturaAnpr
        }
        if (params instanceof AnscGenerazioneCertificatoParams) {
            ((AnscGenerazioneCertificatoParams) params).atto = atto
            ((AnscGenerazioneCertificatoParams) params).window = self
        }

        params.certificato = saved
        params.onSuccess = { CertificatoGenerato certificatoGenerato ->

            emissioneCertificatoCache.store(saved)

            // Salvo il certificato generato sul certificato emesso
            try {
                emissioneCertificatoService.saveAllegato(saved, certificatoGenerato)
            } catch (DocumentaleRuntimeException dre) {
                log.error(dre.message, dre)

                String msg = "${getEtichetta(EtichetteMessaggi.Errore_salvataggio_file_documentale)}"
                MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.W, msg)
            }

            // Salvo il certificato generato sul documento anagrafico
            if (documentoAnagrafico != null && saveDocumentoAnagrafico) {
                try {
                    emissioneCertificatoService.saveDocumentoAnagraficoAllegato(documentoAnagrafico, saved, certificatoGenerato)
                    String msg = String.format(getEtichetta(EtichetteMessaggi.Info_Archiviazione_Documento_Individuo), documentoAnagrafico.tipoDocumento.id, documentoAnagrafico.numero)
                    MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.I, msg)
                } catch (DocumentaleRuntimeException dre) {
                    log.error(dre.message, dre)

                    String msg = "${getEtichetta(EtichetteMessaggi.Errore_salvataggio_file_documentale_individuo)}"
                    MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.W, msg)
                }
            }
        }
        params.onFailure = { Exception ex ->
            log.error(ex.message, ex)

            // Annullo il certificato emesso se la generazione fallisce
            String noteAnnullamento = "Errore durante elaborazione:\n${ex.message}"
            cerCertificatoEmessoService.annullaCertificato(saved, noteAnnullamento)

            if (!(ex instanceof De4gsdzkRuntimeException)) {
                throw ex
            }

            String msg = calculateErrorMessage(ex as De4gsdzkRuntimeException, saved)
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, msg)
        }

        // Genero il certificato
        generazioneCertificatoService.generateCertificato(params)
    }

    private String calculateErrorMessage(De4gsdzkRuntimeException ex, CerCertificatoEmesso saved) {
        if (ex instanceof GenerazioneCertificatoRuntimeExceptionBase) {
            GenerazioneCertificatoRuntimeExceptionBase gcrex = (GenerazioneCertificatoRuntimeExceptionBase) ex
            String msg = "${getEtichetta(gcrex.etichetta)}\n\n$gcrex.generationError\n\nCertificato annullato ai fini del conteggio dei diritti (se previsti)."
            if (gcrex instanceof AnprGenerazioneCertificatoRuntimeException || gcrex instanceof AnscGenerazioneCertificatoRuntimeException) {
                msg = "$msg\nAttenzione: annullamento valido solo per il certificato locale."
            }
            return msg
        }

        if (ex instanceof ErroreModelloNonTrovatoRuntimeException) {
            ErroreModelloNonTrovatoRuntimeException emntrex = (ErroreModelloNonTrovatoRuntimeException) ex
            return "$saved.tipoCertificato.descrizione\n${getEtichetta(emntrex.getEtichetta()) ?: emntrex.getMessage()}"
        }

        De4gsdzkRuntimeException drex = (De4gsdzkRuntimeException) ex
        return getEtichetta(drex.getEtichetta()) ?: drex.getMessage()
    }

    @Command
    void onOpenFondoCassa() {
        openFondoCassa()
    }

    private openFondoCassa() {
        Window popupScansione = (Window) Executions.createComponents('/restrict/certificazione/popupFondoCassa.zul', self, [terminalista: terminalista])
        popupScansione.doModal()
    }

    @Command
    void onOpenMessaggiIndividuo() {
        openMessaggiIndividuo()
    }

    private openMessaggiIndividuo() {
        Window popupScansione = (Window) Executions.createComponents('/restrict/afc/popupAvvisi.zul', self, [listaMessaggi: beneficiarioState.messaggioList])
        popupScansione.doModal()
    }

}
