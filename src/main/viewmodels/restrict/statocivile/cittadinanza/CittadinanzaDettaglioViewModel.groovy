package restrict.statocivile.cittadinanza

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreCaricamentoDatiRuntimeException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.event.InputEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CittadinanzaDettaglioViewModel extends CittadinanzaDettaglioParentViewModel{

    ETipoSiNo numeraAtto

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivCittadinanzaService civCittadinanzaService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    @WireVariable
    private CivAnagrafeService civAnagrafeService

    @WireVariable
    private CivMargineService civMargineService

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoDomain") CivTipoAtto tipoAttoDomain) {
        if (id){
            statoFrammenti = 2
        } else {
            statoFrammenti = 0
        }

        this.composizioneTestoAttiva = Boolean.TRUE

        saveRecordEnabled = true
        deleteRecordEnabled = true

        super.doInit(w, id, tipoAttoDomain)
    }

    void creaDettaglio(Map params){
        tipoOperazione = ETipoOperazione.INS

        try {
            dettaglio = new CivCittadinanza(anno: Calendar.getInstance().get(Calendar.YEAR), codiceRecord: new Integer(3))
            dettaglio.ufficio = gsdService.getLoggedUserUfficio()

            anagrafe = new CivAnagrafe()

            margine = new CivMargine()

            mapFormule = [:]

            formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

            CivTipoAtto tipoAttoDomain = params.tipoAttoDomain
            dettaglio.tipoAttoDomain = tipoAttoDomain
            dettaglio.natura = tipoAttoDomain?.natura
            if (tipoAttoDomain && (dettaglio.ufficio != null) && (dettaglio.anno != null)) {
                numeraAtto = ETipoSiNo.SI
                onSelectNumera()
            }

            datiProvenienza = civDatiProvenienzaAttoService.create()
            // Solo per atti in inserimento e integrazione ANSC attiva
            if ( anscOn && dettaglio.isCodRec3() && dettaglio.isComprensioneDichiaranteVisibile() ) {
                datiProvenienza.comprensioneDichiarante = getDefaultComprensione()
            }

            caricaListaAnnotazioniNascita()

            caricaListaTipoRichiesta()

        } catch (CompetenzeRuntimeException ex){
            Messagebox.show((getEtichetta(ex.getEtichetta())?:ex.getMessage()), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            onChiudi()
        }
    }

    void caricaListaAnnotazioniNascita(){
        listaAnnotazioniNascita = [null]
        // Le annotazioni sono da gestire solo per gli atti in inserimento e non per i consolidati/pregressi
        if ( isCaricamentoFormuleAnnotazioneAbilitato() ) {
            List<String> l = gsdService.listFormuleAnnotazione(dettaglio.tipoAtto, [categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice, tipoAttoAnnotazione: ETipoAtto.NAS.valore])
            if (l.size() > 0) {
                listaAnnotazioniNascita.addAll(civFormulaAnnotazioneService.listAllByIdIn(l))
            }
        }
    }

    void caricaDettaglio(def id) {
        if (id) {
            try{
                dettaglio = civCittadinanzaService.get(id, [fetch:[[campo:'nazionalita1', tipo: JoinType.LEFT], [campo:'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT],
                                                                   [campo:'motivoCittadinanza', tipo: JoinType.LEFT], [campo:'utenteUpd', tipo: JoinType.LEFT]]])

                numeraAtto = (dettaglio.isProvvisorio()?ETipoSiNo.NO:ETipoSiNo.SI)

                tipoOperazione = ETipoOperazione.UPD

                caricaListaStatoCivile()

                formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

                buttonConsolidamentoLabel = FormUtils.getAttoButtonConsolidamentoLabel(dettaglio, etichette)

                //Se su CIVANA esiste un record associato all'atto, devo tirarlo su; se non esiste, NON devo creare uns nuova istanza di CIVANA in quanto si incasinerebbe il salvataggio su ANAANA
                if (dettaglio.isCodRec3()) {
                    anagrafe = civAnagrafeService.getByUkAttoAndTipoAtto(dettaglio.idAtto, dettaglio.tipoAtto)
                } else {
                    anagrafe = null
                }

                // Anche in modifica occorre istanziare un nuovo CivMargine se non esitente
                margine = civMargineService.getOrCreateByUkAtto(dettaglio)

                caricaListaSoggettiCollegati()

                // Rispetto all'inserimento, occorre istanziare un nuovo CivDatiProvenienzaAtto senza prevalorizzare alcun attributo
                datiProvenienza = civDatiProvenienzaAttoService.getOrCreateByUkAtto(dettaglio)
                // Solo per atti in cod_rec 3
                if ( dettaglio.isCodRec3() && dettaglio.isComprensioneDichiaranteVisibile() && (datiProvenienza.comprensioneDichiarante == null) ){
                    datiProvenienza.comprensioneDichiarante = getDefaultComprensione()
                }
                onSelectDichiarante()

                caricaListaAnnotazioniNascita()
                caricaListaAnnotazioniDaAtto()
                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1()

                DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)
                DomainUtils.allineaTestoMinuscole(datiProvenienza, minuscole)

                caricaFormuleAtto()

                anscEnabled = (anscOn && dettaglio.isCodRec0() && (dettaglio.numeroUnico != null) )

                caricaListaTrasmissioneCittadinanza()

                caricaListaTipoRichiesta()

                refreshUi()

                updateStateHash()

            } catch (Exception ex){
                log.error("Errore apertura record", ex)
                String errorMsg = getEtichetta(Etichette.getEtichetta("Errore_apertura_record"))
                if (ex instanceof ErroreCaricamentoDatiRuntimeException){
                    errorMsg = (getEtichetta(ex.getEtichetta())?:ex.getMessage())
                }
                Messagebox.show(errorMsg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                onChiudi()
            }
        }
    }

    void numera(){
        dettaglio.atto = gsdService.getNumeroAtto(dettaglio, numeraAtto)
        if (dettaglio.atto == null){
            numeraAtto = null
        }
        refreshUi()
    }

    @Command void onSelectUfficio(){
        if (isUpdatable()){
            numera()
        }
    }

    @Command void onSelectAnno(@ContextParam(ContextType.TRIGGER_EVENT) InputEvent event){
        if (isUpdatable()){
            log.info("Valore anno antecedente la modifica: " + event.previousValue)
            numera()
        }
    }

    protected void salvaAtto(Boolean showAlert=Boolean.TRUE, EGestioneConsolidamento gc=null){
        if (dettaglio && saveRecordEnabled) {

            askStoricizzazione({ Boolean hasBeenStoricizzato ->
                CivCittadinanza c
                try {
                    c = civCittadinanzaService.save(tipoOperazione, dettaglio, anagrafe, datiProvenienza, margine, mapFormule, mapAnnotazioniDaAtto, gc, margineMandatory, listaSoggettiCollegati, hasBeenStoricizzato)
                    if (tipoOperazione.isUpdate() && showAlert && (statoFrammenti == 2)) {
                        Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Aggiornamento_Formule")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    }
                    if (statoFrammenti == 1) {
                        statoFrammenti = 2
                    }
                } catch (RuntimeException ex) {
                    if (gc) {
                        civCittadinanzaService.ripristina(tipoOperazione, dettaglio, gc)
                    }
                    refreshUi()
                    throw ex
                }
                if (c) {
                    caricaDettaglio(c.id)
                }
            })
        }
    }

    CivAttoBaseDomain getAtto(){
        return this.dettaglio
    }

    @Command void onCheckConsolidamento() {
        if (isDaConsolidareOBloccare()) {
            if (dettaglio.natura == ENaturaAtto.N){
                annullaAtto()
            } else {
                Integer codRec = civCittadinanzaService.getCodiceRecord(dettaglio.id)
                if (codRec.intValue() == 0) {
                    bloccaAtto()
                } else {
                    selezionaConsolidamentoAtto(EGestioneConsolidamento.CONSOLIDAMENTO, EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO)
                }
            }
        }
    }

    void consolidaAtto (EGestioneConsolidamento gc){
        salvaAtto(Boolean.FALSE, gc)

        if (anscOn){
            //TODO: disabilito temporaenamente automatismo sulla gestione minori da riattivare dopo analisi cdu specifici ANSC
            checkComunicazioniDaAnnotazione()
        } else {
            int countMinorenni = gsdService.countMinorenni(dettaglio.idAtto)
            if (countMinorenni > 0){
                Messagebox.show(String.format(getEtichetta(Etichette.getEtichetta("Ask_Gestione_Minorenni")), dettaglio.getNominativo() ), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                        new org.zkoss.zk.ui.event.EventListener(){
                            void onEvent(Event e){
                                if (Messagebox.ON_YES.equals(e.getName())){
                                    Window w = (Window) Executions.createComponents("/restrict/statocivile/cittadinanza/cittadinanzaMinorenniListaSelect.zul", self.parent, [atto: dettaglio])
                                    w.addEventListener(Events.ON_CLOSE, { event ->
                                        checkComunicazioniDaAnnotazione()
                                    })
                                    w.doModal()
                                } else {
                                    checkComunicazioniDaAnnotazione()
                                }
                            }
                        }
                )
            } else {
                checkComunicazioniDaAnnotazione()
            }
        }
    }

    @Command void onSelectRecuperoDaGiuramentoORichiesta() {
        if (dettaglio.isAcquisto() || dettaglio.isAttestazioneSindacoDiciottenne()) {
            String uri = "/restrict/statocivile/cittadinanza/cittadinanzaSelect.zul"
            Window w = (Window) Executions.createComponents(uri, self.parent, [categoriaDomain: dettaglio.tipoAttoDomain?.categoriaDomain])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data?.idCittadinanza != null) {
                    Map params = [fetch: [[campo: 'nazionalita1', tipo: JoinType.LEFT]]]
                    CivCittadinanza cGiu = civCittadinanzaService.get(event.data.idCittadinanza, params)

                    AnaAnagrafe ana1 = null
                    if (event.data?.idAnagrafe1 != null){
                        ana1 = anaAnagrafeService.get(event.data.idAnagrafe1)
                    }
                    anagrafe.anagrafe1 = ana1

                    if (cGiu) {
                        CivMargine mGiu = civMargineService.getByUkAtto(cGiu.idAtto)

                        DomainUtils.initSoggetto1FromSoggetto1(dettaglio, cGiu)

                        if(arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()){
                            DomainUtils.initEstremiAttoNascitaFromMargineNuovaGestioneAnnotazione(margine, mGiu)
                        } else {
                            DomainUtils.initEstremiAttoNascitaFromMargine(margine, mGiu)
                        }

                        recuperaEstremiAttoNascitaSoggetto1DaAttoDiNascita()
                        //refs #73154
                        DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)

                        dettaglio.dataGiuramento = cGiu.dataGiuramento
                        dettaglio.dataDecorrenza = cGiu.dataDecorrenza

                        if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
                            DomainUtils.initEstremiGiuramentoFromCittadinanzaNuovaGestioneAnnotazione(datiProvenienza, cGiu)
                        } else {
                            DomainUtils.initEstremiGiuramentoFromCittadinanza(datiProvenienza, cGiu)
                        }

                        // per chiarezza ai fini dell'integrazione con ANSC
                        riempiComune(datiProvenienza.comuneGiuramento, gsdService.getComuneCliente())

                        CivDatiProvenienzaAtto dpGiu = civDatiProvenienzaAttoService.getByUkAtto(cGiu.idAtto)
                        datiProvenienza.numeroSentenza = dpGiu?.numeroSentenza
                        datiProvenienza.dataSentenza = dpGiu?.dataSentenza
                        datiProvenienza.dataNotificaSentenza = dpGiu?.dataNotificaSentenza
                        datiProvenienza.tribunaleSentenza = dpGiu?.tribunaleSentenza
                    }
                    refreshUi()
                }
            })
            w.doModal()
        }
    }

}
