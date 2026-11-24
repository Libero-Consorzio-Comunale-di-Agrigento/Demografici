package restrict.statocivile.morte

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreCaricamentoDatiRuntimeException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MortePregressoDettaglioViewModel extends MorteDettaglioParentViewModel {

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivMorteService civMorteService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    @WireVariable
    private CivMargineService civMargineService

    @WireVariable
    private CivTrasportoESeppellimentoService civTrasportoESeppellimentoService

    // ------------------ Servizi per Trait TrasportoESeppellimento ---------------------
    //
    @WireVariable
    CivNumerazioneDocumentiUscitaService civNumerazioneDocumentiUscitaService
    //
    // -------------------- ---------------------------------- --------------------------

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoDomain") CivTipoAtto tipoAttoDomain,
         @ExecutionArgParam("composizioneTestoAttiva") Boolean composizioneTestoAttiva) {
        statoFrammenti = 0

        this.composizioneTestoAttiva = composizioneTestoAttiva

        saveRecordEnabled = true
        deleteRecordEnabled = true

        super.doInit(w, id, tipoAttoDomain)
    }

    void creaDettaglio(Map params) {
        tipoOperazione = ETipoOperazione.INS

        try {
            dettaglio = new CivMorte(codiceRecord: new Integer(0), estremiDecessoNoti: ETipoSiNo.SI, morteViolenta: ETipoSiNo.NO)
            dettaglio.ufficio = gsdService.getLoggedUserUfficio()

            //Nel caso di inserimento di un pregresso non devo creare il collegamento con CivAnagrafe

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

            datiProvenienza = new CivDatiProvenienzaAtto()
            if (dettaglio.isSecondaB()) {
                datiProvenienza.documentoDecesso = getEtichetta(Etichette.getEtichetta("Avviso_morte"))
            }

            caricaListaComparente()

            setComuneDecessoAuto()

        } catch (CompetenzeRuntimeException ex) {
            Messagebox.show((getEtichetta(ex.getEtichetta()) ?: ex.getMessage()), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            onChiudi()
        }
    }

    void caricaDettaglio(def id) {
        if (id) {
            try {
                dettaglio = civMorteService.get(id, [fetch: [[campo: 'nazionalita', tipo: JoinType.LEFT], [campo: 'nazionalitaConiuge', tipo: JoinType.LEFT],
                                                             [campo: 'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT], [campo: 'utenteUpd', tipo: JoinType.LEFT]]])

                tipoOperazione = ETipoOperazione.UPD

                caricaListaStatoCivile()

                formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

                buttonConsolidamentoLabel = FormUtils.getAttoButtonConsolidamentoLabel(dettaglio, etichette)

                // Per un pregresso non devo salvare su CIVANA

                // Anche in modifica occorre istanziare un nuovo CivMargine se non esitente
                margine = civMargineService.getOrCreateByUkAtto(dettaglio)

                caricaListaSoggettiCollegati()

                // Rispetto all'inserimento, occorre istanziare un nuovo CivDatiProvenienzaAtto senza prevalorizzare alcun attributo
                datiProvenienza = civDatiProvenienzaAttoService.getOrCreateByUkAtto(dettaglio)
                caricaListaComparente()
                onSelectComparente()

                // In modifica istanzio un nuovo CivTrasportoESeppellimento (se non esitente) ma salvo solo in funzione di flag opportuno
                trasporto = civTrasportoESeppellimentoService.getOrCreateByUkAtto(dettaglio.idAtto)

                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1()

                DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)
                DomainUtils.allineaTestoMinuscole(datiProvenienza, minuscole)
                DomainUtils.allineaTestoMinuscole(trasporto, minuscole)

                if (composizioneTestoAttiva && (statoFrammenti == 2)) {
                    caricaFormuleAtto()
                }

                previewModelloIstatOpenOn = (dettaglio.hasModelloD4 || dettaglio.hasModelloD4Bis)

                anscEnabled = (anscOn && (dettaglio.numeroUnico != null))

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

    CivAttoBaseDomain getAtto() {
        return this.dettaglio
    }

    protected void salvaAtto(Boolean showAlert = Boolean.TRUE, EGestioneConsolidamento gc = null) {
        if (dettaglio && saveRecordEnabled) {
            askStoricizzazione({ Boolean hasBeenStoricizzato ->
                String msg = checkEstremiProtocollo()
                if (msg) {
                    Messagebox.show(msg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                }
                CivMorte c
                try {
                    Map<String, CivNumerazioneDocumentiUscita> nd = [:]
                    nd.put(CivTipoRegistro.ID_TRASPORTO, numerazioneDocumentoTrasporto)
                    nd.put(CivTipoRegistro.ID_SEPPELLIMENTO, numerazioneDocumentoSeppellimento)
                    nd.put(CivTipoRegistro.ID_CREMAZIONE, numerazioneDocumentoCremazione)
                    c = civMorteService.save(tipoOperazione, dettaglio, null, datiProvenienza, margine, trasporto, nd, mapFormule, null, composizioneTestoAttiva, gc, margineMandatory, listaSoggettiCollegati, [:], hasBeenStoricizzato)
                    if (tipoOperazione.isUpdate() && showAlert && composizioneTestoAttiva) {
                        Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Aggiornamento_Formule")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    }
                    if (composizioneTestoAttiva && (statoFrammenti == 1)) {
                        statoFrammenti = 2
                    }
                } catch (RuntimeException ex) {
                    if (gc) {
                        civMorteService.ripristina(tipoOperazione, dettaglio, gc)
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

    @Command
    void onCheckConsolidamento() {
        if (isDaConsolidareOBloccare()) {
            if (dettaglio.natura == ENaturaAtto.N) {
                annullaAtto()
            } else {
                bloccaAtto()
            }
        }
    }

}
