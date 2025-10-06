package restrict.statocivile.unione.unione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreCaricamentoDatiRuntimeException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.InputEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class UnioneCivileDettaglioViewModel extends UnioneCivileDettaglioParentViewModel{

    ETipoSiNo numeraAtto

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivUnioneCivileService civUnioneCivileService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    @WireVariable
    private CivAnagrafeService civAnagrafeService

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    @WireVariable
    private CivMargineService civMargineService

    @WireVariable
    private CivSposiAttoService civSposiAttoService

    @WireVariable
    private CivTestimoniAttoService civTestimoniAttoService

    @WireVariable
    private CivProcessoVerbaleService civProcessoVerbaleService

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @WireVariable
    private CivDocumentoPubblicazioneService civDocumentoPubblicazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoDomain") CivTipoAtto tipoAttoDomain) {
        if (id){
            statoFrammenti = 2
        } else {
            statoFrammenti = 0
        }

        this.composizioneTestoAttiva = Boolean.TRUE

        saveRecordEnabled = true
        deleteRecordEnabled = true

        doInit(w, id, tipoAttoDomain)
    }

    void creaDettaglio(Map params){
        tipoOperazione = ETipoOperazione.INS

        try {
            dettaglio = new CivUnioneCivile(anno: Calendar.getInstance().get(Calendar.YEAR), codiceRecord: new Integer(3), certificabile: ETipoSiNo.NO)
            dettaglio.ufficio = statoCivileService.getLoggedUserUfficio()
            // Solo per atti in inserimento e integrazione ANSC attiva
            if (anscOn){
                // ulteriori inizializzazioni in funzione di parte/serie/cat dopo il recupero del tipo atto
                dettaglio.comprensione1 = getDefaultComprensione()
                dettaglio.comprensione2 = getDefaultComprensione()
            }

            anagrafe = new CivAnagrafe()

            margine = new CivMargine()

            sposi = new CivSposiAtto()

            documentoPubblicazione = new CivDocumentoPubblicazione()

            mapFormule = [:]

            formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

            CivTipoAtto tipoAttoDomain = params.tipoAttoDomain
            dettaglio.tipoAttoDomain = tipoAttoDomain
            dettaglio.parte = tipoAttoDomain?.parte
            dettaglio.serie = tipoAttoDomain?.serie
            dettaglio.natura = tipoAttoDomain?.natura
            if (tipoAttoDomain && (dettaglio.ufficio != null) && (dettaglio.anno != null)) {
                numeraAtto = ETipoSiNo.SI
                onSelectNumera()
            }

            datiProvenienza = civDatiProvenienzaAttoService.create()
            if (dettaglio.isFuoriCasaComunale() || dettaglio.isPericoloVita()){
                datiProvenienza.flagCasaComunale = Boolean.FALSE
            }
            if (anscOn && dettaglio.isCivileXDelega()){
                datiProvenienza.flagCasaComunale = Boolean.TRUE
            }
            // Solo per atti in inserimento e integrazione ANSC attiva
            if (anscOn){
                if (dettaglio.isImpedimentoGenericoVisibile()) {
                    datiProvenienza.impedimentoGenericoUci = EImpedimentoGenericoUnioneCivile.NE
                }
            }

            if ( dettaglio.isTestimoniVisibile() ) {
                Integer numTestimoni = (dettaglio.isTestimoniMandatory()?new Integer(2):null)
                testimoni = civTestimoniAttoService.create(numTestimoni)
            }

            caricaListaDichiarante()

            setComuneUciAuto()

            caricaListaAnnotazioniNascita()
            if (dettaglio.isUnioneCivileConiugi()){
                caricaListaAnnotazioniMatrimonio()
            }

        } catch (CompetenzeRuntimeException ex){
            Messagebox.show((getEtichetta(ex.getEtichetta())?:ex.getMessage()), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            onChiudi()
        }
    }

    void caricaListaAnnotazioniNascita(){
        listaAnnotazioniNascita = [null]
        // Le annotazioni sono da gestire solo per gli atti in inserimento e non per i consolidati/pregressi
        if ( isCaricamentoFormuleAnnotazioneAbilitato() ) {
            List<String> l = statoCivileService.listFormuleAnnotazione(dettaglio.tipoAtto, [categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice, tipoAttoAnnotazione: ETipoAtto.NAS.valore])
            if (l.size() > 0) {
                listaAnnotazioniNascita.addAll(civFormulaAnnotazioneService.listAllByIdIn(l))
            }
        }
    }

    void caricaListaAnnotazioniMatrimonio(){
        listaAnnotazioniMatrimonio = [null]
        // Le annotazioni sono da gestire solo per gli atti in inserimento e non per i consolidati/pregressi
        if ( dettaglio.isUnioneCivileConiugi() && isCaricamentoFormuleAnnotazioneAbilitato() ) {
            List<String> l = statoCivileService.listFormuleAnnotazione(dettaglio.tipoAtto, [categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice, tipoAttoAnnotazione: ETipoAtto.MAT.valore])
            if (l.size() > 0) {
                listaAnnotazioniMatrimonio.addAll(civFormulaAnnotazioneService.listAllByIdIn(l))
            }
        }
    }

    void caricaDettaglio(def id) {
        if (id) {
            try{
                dettaglio = civUnioneCivileService.get(id, [fetch:[[campo:'nazionalita1', tipo: JoinType.LEFT], [campo:'nazionalita2', tipo: JoinType.LEFT],
                                                                   [campo:'comprensione1', tipo: JoinType.LEFT], [campo:'comprensione2', tipo: JoinType.LEFT],
                                                                   [campo:'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT], [campo:'utenteUpd', tipo: JoinType.LEFT]]])

                // Solo per atti in inserimento e integrazione ANSC attiva
                if ( anscOn && dettaglio.isCodRec3() && (dettaglio.comprensione1 == null) ){
                    dettaglio.comprensione1 = getDefaultComprensione()
                }
                if ( anscOn && dettaglio.isCodRec3() && (dettaglio.comprensione2 == null) ){
                    dettaglio.comprensione2 = getDefaultComprensione()
                }
                numeraAtto = (dettaglio.isProvvisorio()?ETipoSiNo.NO:ETipoSiNo.SI)

                tipoOperazione = ETipoOperazione.UPD

                formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

                buttonConsolidamentoLabel = FormUtils.getAttoButtonConsolidamentoLabel(dettaglio, etichette)

                //Se su CIVANA esiste un record associato all'atto, devo tirarlo su; se non esiste, NON devo creare uns nuova istanza di CIVANA in quanto si incasinerebbe il salvataggio su ANAANA
                if (dettaglio.isCodRec3()) {
                    anagrafe = civAnagrafeService.getByUkAttoAndTipoAtto(dettaglio.idAtto, dettaglio.tipoAtto)
                } else {
                    anagrafe = null
                }

                // Anche in modifica occorre istanziare un nuovo CivMargine se non esistente
                margine = civMargineService.getOrCreateByUkAtto(dettaglio)

                // Anche in modifica occorre istanziare un nuovo CivSposiAtto se non esistente
                sposi = civSposiAttoService.getOrCreateByUkAttoAndTipoAtto(dettaglio.idAtto, dettaglio.tipoAtto)

                if ( dettaglio.isTestimoniVisibile() ){
                    // Anche in modifica occorre istanziare un nuovo CivTestimoniAtto se non esistente
                    testimoni = civTestimoniAttoService.getOrCreateByUkAtto(dettaglio, dettaglio.tipoAtto)
                    DomainUtils.allineaTestoMinuscole(testimoni, minuscole)
                }

                // Anche in modifica occorre istanziare un nuovo CivDocumentoPubblicazione se non esistente
                documentoPubblicazione = civDocumentoPubblicazioneService.getOrCreateByUkAttoAndTipoAtto(dettaglio.idAtto, dettaglio.tipoAtto)

                caricaListaSoggettiCollegati()

                // Rispetto all'inserimento, occorre istanziare un nuovo CivDatiProvenienzaAtto senza prevalorizzare alcun attributo
                datiProvenienza = civDatiProvenienzaAttoService.getOrCreateByUkAtto(dettaglio)
                if (dettaglio.isFuoriCasaComunale() || dettaglio.isPericoloVita()){
                    datiProvenienza.flagCasaComunale = Boolean.FALSE
                }
                caricaListaDichiarante()
                onSelectDichiarante()

                caricaListaAnnotazioniNascita()
                caricaListaAnnotazioniMatrimonio()
                caricaListaAnnotazioniDaAtto()

                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1()
                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto2()

                DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)
                DomainUtils.allineaTestoMinuscole(datiProvenienza, minuscole)

                caricaFormuleAtto()

                previewModelloIstatOpenOn = dettaglio.hasModelloD3U

                anscEnabled = (anscOn && dettaglio.isCodRec0() && (dettaglio.numeroUnico != null) )

                refreshUi()

                updateStateHash()

            } catch (Exception ex){
                log.error("Errore apertura record", ex)
                String errorMsg = getEtichetta(EtichetteMessaggi.Errore_apertura_record)
                if (ex instanceof ErroreCaricamentoDatiRuntimeException){
                    errorMsg = (getEtichetta(ex.getEtichetta())?:ex.getMessage())
                }
                Messagebox.show(errorMsg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                onChiudi()
            }
        }
    }

    void numera(){
        dettaglio.atto = statoCivileService.getNumeroAtto(dettaglio, numeraAtto)
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
                CivUnioneCivile c
                try {
                    c = civUnioneCivileService.save(tipoOperazione, dettaglio, anagrafe, datiProvenienza, margine, sposi, testimoni, documentoPubblicazione, mapFormule, mapAnnotazioniDaAtto, gc, margineMandatory, listaSoggettiCollegati, hasBeenStoricizzato)
                    if (tipoOperazione.isUpdate() && showAlert && (statoFrammenti == 2)) {
                        Messagebox.show(getEtichetta(EtichetteMessaggi.Warn_Aggiornamento_Formule), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    }
                    if (statoFrammenti == 1) {
                        statoFrammenti = 2
                    }
                } catch (RuntimeException ex) {
                    if (gc) {
                        civUnioneCivileService.ripristina(tipoOperazione, dettaglio, gc)
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
        if (isDaConsolidareOBloccare()){
            if (dettaglio.natura == ENaturaAtto.N){
                annullaAtto()
            } else {
                Integer codRec = civUnioneCivileService.getCodiceRecord(dettaglio.id)
                if (codRec.intValue() == 0) {
                    bloccaAtto()
                } else {
                    selezionaConsolidamentoAtto(EGestioneConsolidamento.CONSOLIDAMENTO_CERTIFICAZIONE, EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO_CERTIFICAZIONE)
                }
            }
        }
    }

    void consolidaAtto (EGestioneConsolidamento gc){
        salvaAtto(Boolean.FALSE, gc)

        checkComunicazioniDaAnnotazione()
    }

    @Command void onSelectRecuperoDaVerbale() {
        String uri = "/restrict/statocivile/pubbPvuSelect.zul"
        Window w = (Window) Executions.createComponents(uri, self.parent, [tipoAttoEnum:dettaglio.getTipoAttoEnum()])
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            if (event.data?.idVerbale != null){
                Map params = [fetch: [[campo:'nazionalita1', tipo: JoinType.LEFT], [campo:'nazionalita2', tipo: JoinType.LEFT]]]
                CivProcessoVerbale p = civProcessoVerbaleService.get(event.data.idVerbale, params)

                AnaAnagrafe ana1 = null
                if (event.data?.idAnagrafe1 != null){
                    ana1 = anaAnagrafeService.get(event.data.idAnagrafe1)
                }
                anagrafe.anagrafe1 = ana1

                AnaAnagrafe ana2 = null
                if (event.data?.idAnagrafe2 != null){
                    ana2 = anaAnagrafeService.get(event.data.idAnagrafe2)
                }
                anagrafe.anagrafe2 = ana2

                if (p) {
                    CivSposiAtto sposiPvu = civSposiAttoService.getByUkAttoAndTipoAtto(p.idAtto, p.tipoAtto)

                    DomainUtils.initDatiMatUciFromPubblicazione(dettaglio, p)
                    //In più rispetto alle pubblicazioni
                    dettaglio.dataMatrimonio = p.dataUnioneCivile

                    DomainUtils.initSoggetto1FromSoggetto1(dettaglio, p)

                    DomainUtils.initSoggetto2FromSoggetto2(dettaglio, p)

                    if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
                        DomainUtils.initEstremiAttoNascitaFromSposiNuovaGestioneAnnotazione(sposi, sposiPvu)
                    } else {
                        DomainUtils.initEstremiAttoNascitaFromSposi(sposi, sposiPvu)
                    }

                    recuperaEstremiAttoNascitaSoggetto1DaAttoDiNascita()

                    recuperaEstremiAttoNascitaSoggetto2DaAttoDiNascita()
                    //refs #73154
                    DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)

                    CivDocumentoPubblicazione dp = civDocumentoPubblicazioneService.getByUkAttoAndTipoAtto(p.idAtto, p.tipoAtto)
                    if (dp) {
                        documentoPubblicazione.documentoPresentatoPubblicazione = dp.documentoPresentatoPubblicazione

                        documentoPubblicazione.documentiProdotti = dp.documentiProdotti
                        documentoPubblicazione.documentiAcquisiti = dp.documentiAcquisiti

                        documentoPubblicazione.dataEstratto1 = dp.dataEstratto1
                        documentoPubblicazione.comuneEstratto1 = dp.comuneEstratto1

                        documentoPubblicazione.dataCumulativo1 = dp.dataCumulativo1
                        documentoPubblicazione.comuneCumulativo1 = dp.comuneCumulativo1

                        documentoPubblicazione.dataEstratto2 = dp.dataEstratto2
                        documentoPubblicazione.comuneEstratto2 = dp.comuneEstratto2

                        documentoPubblicazione.dataCumulativo2 = dp.dataCumulativo2
                        documentoPubblicazione.comuneCumulativo2 = dp.comuneCumulativo2
                    }
                }
                refreshUi()
            }
        })
        w.doModal()
    }

}
