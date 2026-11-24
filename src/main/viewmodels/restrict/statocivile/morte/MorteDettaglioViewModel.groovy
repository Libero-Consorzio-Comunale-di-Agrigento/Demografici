package restrict.statocivile.morte

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreAssenzaTipoSalvataggioAnnotazioneComuneClienteSuAttoNascita1RuntimeException
import it.finmatica.de4gsdzk.errors.ErroreCaricamentoDatiRuntimeException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.InputEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MorteDettaglioViewModel extends MorteDettaglioParentViewModel {

    ETipoSiNo numeraAtto

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivMorteService civMorteService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    @WireVariable
    private CivAnagrafeService civAnagrafeService

    @WireVariable
    private CivMargineService civMargineService

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @WireVariable
    private CivTrasportoESeppellimentoService civTrasportoESeppellimentoService

    // ------------------ Servizi per Trait TrasportoESeppellimento ---------------------
    //
    @WireVariable
    CivNumerazioneDocumentiUscitaService civNumerazioneDocumentiUscitaService
    //
    // -------------------- ---------------------------------- --------------------------

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoDomain") CivTipoAtto tipoAttoDomain) {
        if (id) {
            statoFrammenti = 2
        } else {
            statoFrammenti = 0
        }

        this.composizioneTestoAttiva = Boolean.TRUE

        saveRecordEnabled = true
        deleteRecordEnabled = true

        super.doInit(w, id, tipoAttoDomain)
    }

    void creaDettaglio(Map params) {
        tipoOperazione = ETipoOperazione.INS

        try {
            dettaglio = new CivMorte(anno: Calendar.getInstance().get(Calendar.YEAR), codiceRecord: new Integer(3),
                    certificabile: ETipoSiNo.NO, estremiDecessoNoti: ETipoSiNo.SI, morteViolenta: ETipoSiNo.NO)
            dettaglio.ufficio = gsdService.getLoggedUserUfficio()

            anagrafe = new CivAnagrafe()

            margine = new CivMargine()

            // Istanzio un nuovo CivTrasportoESeppellimento, ma salvo solo in funzione di flag opportuno
            trasporto = new CivTrasportoESeppellimento()

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
            // Solo per atti in cod_rec 3
            if (dettaglio.isCodRec3() && dettaglio.isComprensioneDichiaranteVisibile()) {
                datiProvenienza.comprensioneDichiarante = getDefaultComprensione()
            }
            if (dettaglio.isSecondaB()) {
                datiProvenienza.documentoDecesso = getEtichetta(Etichette.getEtichetta("Avviso_morte"))
            }

            caricaListaComparente()

            setComuneDecessoAuto()

            caricaListaAnnotazioniNascita()

        } catch (CompetenzeRuntimeException ex) {
            Messagebox.show((getEtichetta(ex.getEtichetta()) ?: ex.getMessage()), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            onChiudi()
        }
    }

    void caricaListaAnnotazioniNascita() {
        listaAnnotazioniNascita = [null]
        // Le annotazioni sono da gestire solo per gli atti in inserimento e non per i consolidati/pregressi
        if (isCaricamentoFormuleAnnotazioneAbilitato()) {
            List<String> l = gsdService.listFormuleAnnotazione(dettaglio.tipoAtto, [categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice, tipoAttoAnnotazione: ETipoAtto.NAS.valore])
            if (l.size() > 0) {
                listaAnnotazioniNascita.addAll(civFormulaAnnotazioneService.listAllByIdIn(l))
            }
        }
    }

    void caricaDettaglio(def id) {
        if (id) {
            try {
                dettaglio = civMorteService.get(id, [fetch: [[campo: 'nazionalita', tipo: JoinType.LEFT], [campo: 'nazionalitaConiuge', tipo: JoinType.LEFT],
                                                             [campo: 'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT], [campo: 'utenteUpd', tipo: JoinType.LEFT]]])

                numeraAtto = (dettaglio.isProvvisorio() ? ETipoSiNo.NO : ETipoSiNo.SI)

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
                if (dettaglio.isCodRec3() && dettaglio.isComprensioneDichiaranteVisibile() && (datiProvenienza.comprensioneDichiarante == null)) {
                    datiProvenienza.comprensioneDichiarante = getDefaultComprensione()
                }
                caricaListaComparente()
                onSelectComparente()

                // In modifica istanzio un nuovo CivTrasportoESeppellimento (se non esitente) ma salvo solo in funzione di flag opportuno
                trasporto = civTrasportoESeppellimentoService.getOrCreateByUkAtto(dettaglio.idAtto)

                caricaListaAnnotazioniNascita()
                caricaListaAnnotazioniDaAtto()
                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1()

                DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)
                DomainUtils.allineaTestoMinuscole(datiProvenienza, minuscole)
                DomainUtils.allineaTestoMinuscole(trasporto, minuscole)

                caricaFormuleAtto()

                previewModelloIstatOpenOn = (dettaglio.hasModelloD4 || dettaglio.hasModelloD4Bis)

                anscEnabled = (anscOn && dettaglio.isCodRec0() && (dettaglio.numeroUnico != null))

                initNumerazioneDocumenti()

                refreshUi()

                updateStateHash()

            } catch (Exception ex) {
                log.error("Errore apertura record", ex)
                String errorMsg = getEtichetta(Etichette.getEtichetta("Errore_apertura_record"))
                if (ex instanceof ErroreCaricamentoDatiRuntimeException) {
                    errorMsg = (getEtichetta(ex.getEtichetta()) ?: ex.getMessage())
                }
                Messagebox.show(errorMsg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                onChiudi()
            }
        }
    }

    void numera() {
        dettaglio.atto = gsdService.getNumeroAtto(dettaglio, numeraAtto)
        if (dettaglio.atto == null) {
            numeraAtto = null
        }
        refreshUi()
    }

    @Command
    void onSelectUfficio() {
        if (isUpdatable()) {
            numera()
        }
    }

    @Command
    void onSelectAnno(@ContextParam(ContextType.TRIGGER_EVENT) InputEvent event) {
        if (isUpdatable()) {
            log.info("Valore anno antecedente la modifica: " + event.previousValue)
            numera()
        }
    }

    protected void salvaAtto(Boolean showAlert = Boolean.TRUE, EGestioneConsolidamento gc = null) {
        if (dettaglio && saveRecordEnabled) {
            askStoricizzazione({ Boolean hasBeenStoricizzato ->
                String msg = checkEstremiProtocollo()
                if (msg) {
                    Messagebox.show(msg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                }
                try {
                    completaSalvataggio(gc, showAlert, hasBeenStoricizzato)
                } catch (ErroreAssenzaTipoSalvataggioAnnotazioneComuneClienteSuAttoNascita1RuntimeException e) {
                    log.error("Errore dati annotazione atto nascita del deceduto", e)
                    askSalvataggioAnnotazioneSuAttoNascita1 { ETipoSalvataggioAnnotazioneComuneCliente salvataggioAnnotazione ->
                        try {
                            Map<ETipoFormulaAnnotazioneDaAtto, ETipoSalvataggioAnnotazioneComuneCliente> tipoSalvataggioAnnotazioni = [
                                    (ETipoFormulaAnnotazioneDaAtto.NAS_1): salvataggioAnnotazione
                            ]

                            completaSalvataggio(gc, showAlert, tipoSalvataggioAnnotazioni, hasBeenStoricizzato)

                        } catch (RuntimeException ex) {
                            if (gc) {
                                civMorteService.ripristina(tipoOperazione, dettaglio, gc)
                            }
                            refreshUi()
                            throw ex
                        }
                    }
                } catch (RuntimeException ex) {
                    if (gc) {
                        civMorteService.ripristina(tipoOperazione, dettaglio, gc)
                    }
                    refreshUi()
                    throw ex
                }
            })
        }
    }

    private void askSalvataggioAnnotazioneSuAttoNascita1(Closure action) {
        Messagebox.Button[] buttons = [Messagebox.Button.YES, Messagebox.Button.NO, Messagebox.Button.CANCEL]
        String[] buttonsLabel = [getEtichettaEnum(ETipoSalvataggioAnnotazioneComuneCliente.CREA_ATTO_E_SALVA_COMUNE_CLIENTE),
                                 getEtichettaEnum(ETipoSalvataggioAnnotazioneComuneCliente.NON_CREARE_ATTO_E_SALVA_ALTRO_COMUNE),
                                 getEtichetta(Etichette.getEtichetta("Annulla"))]
        HashMap params = [width: 500, sclass: 'redText'] as HashMap
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_annotazione_nascita_mancante")), msgTitle, buttons, buttonsLabel, Messagebox.QUESTION, null, { event ->
            if (event.name == Messagebox.ON_YES) {
                action.call(ETipoSalvataggioAnnotazioneComuneCliente.CREA_ATTO_E_SALVA_COMUNE_CLIENTE)
            }
            if (event.name == Messagebox.ON_NO) {
                action.call(ETipoSalvataggioAnnotazioneComuneCliente.NON_CREARE_ATTO_E_SALVA_ALTRO_COMUNE)
            }
        }, params)
    }

    private completaSalvataggio(EGestioneConsolidamento gc, boolean showAlert, Map<ETipoFormulaAnnotazioneDaAtto, ETipoSalvataggioAnnotazioneComuneCliente> tipoSalvataggioAnnotazioni = [:], boolean hasBeenStoricizzato) {
        Map<String, CivNumerazioneDocumentiUscita> nd = [:]
        nd.put(CivTipoRegistro.ID_TRASPORTO, numerazioneDocumentoTrasporto)
        nd.put(CivTipoRegistro.ID_SEPPELLIMENTO, numerazioneDocumentoSeppellimento)
        nd.put(CivTipoRegistro.ID_CREMAZIONE, numerazioneDocumentoCremazione)
        CivMorte c = civMorteService.save(tipoOperazione, dettaglio, anagrafe, datiProvenienza, margine, trasporto, nd, mapFormule, mapAnnotazioniDaAtto, Boolean.TRUE, gc, margineMandatory, listaSoggettiCollegati, tipoSalvataggioAnnotazioni, hasBeenStoricizzato)
        if (tipoOperazione.isUpdate() && showAlert && (statoFrammenti == 2)) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Aggiornamento_Formule")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
        if (statoFrammenti == 1) {
            statoFrammenti = 2
        }
        if (c) {
            caricaDettaglio(c.id)
        }
    }

    CivAttoBaseDomain getAtto() {
        return this.dettaglio
    }

    @Command
    void onCheckConsolidamento() {
        if (isDaConsolidareOBloccare()) {
            if (dettaglio.natura == ENaturaAtto.N) {
                annullaAtto()
            } else {
                Integer codRec = civMorteService.getCodiceRecord(dettaglio.id)
                if (codRec.intValue() == 0) {
                    bloccaAtto()
                } else {
                    selezionaConsolidamentoAtto(EGestioneConsolidamento.CONSOLIDAMENTO_CERTIFICAZIONE, EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO_CERTIFICAZIONE)
                }
            }
        }
    }

    void consolidaAtto(EGestioneConsolidamento gc) {
        salvaAtto(Boolean.FALSE, gc)

        checkComunicazioniDaAnnotazione()
    }

}
