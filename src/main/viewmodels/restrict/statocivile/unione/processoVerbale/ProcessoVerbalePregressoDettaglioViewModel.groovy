package restrict.statocivile.unione.processoVerbale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
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
class ProcessoVerbalePregressoDettaglioViewModel extends ProcessoVerbaleDettaglioParentViewModel {

    @WireVariable
    private CivProcessoVerbaleService civProcessoVerbaleService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    @WireVariable
    private CivSposiAttoService civSposiAttoService

    @WireVariable
    private CivDocumentoPubblicazioneService civDocumentoPubblicazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoDomain") CivTipoAtto tipoAttoDomain,
               @ExecutionArgParam("composizioneTestoAttiva") Boolean composizioneTestoAttiva) {
        statoFrammenti = 0

        this.composizioneTestoAttiva = composizioneTestoAttiva

        saveRecordEnabled = true
        deleteRecordEnabled = true
        annotazioniEnabled = false

        super.doInit(w, id, tipoAttoDomain)
    }

    void creaDettaglio(Map params) {
        log.info ("Parametri gestiti: " + params?.size() + ": Funzionalità di inserimento di un pregresso non attiva per i processi verbali")
        onChiudi()
    }

    void caricaDettaglio(def id) {
        if (id) {
            try{
                dettaglio = civProcessoVerbaleService.get(id, [fetch:[[campo:'nazionalita1', tipo: JoinType.LEFT], [campo:'nazionalita2', tipo: JoinType.LEFT],
                                                                      [campo:'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT], [campo:'utenteUpd', tipo: JoinType.LEFT]]])

                tipoOperazione = ETipoOperazione.UPD

                formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

                buttonConsolidamentoLabel = FormUtils.getAttoButtonConsolidamentoLabel(dettaglio, etichette)

                // Per un pregresso non devo salvare su CIVANA

                // Anche in modifica occorre istanziare un nuovo CivSposiAtto se non esistente
                sposi = civSposiAttoService.getOrCreateByUkAttoAndTipoAtto(dettaglio.idAtto, dettaglio.tipoAtto)

                // Anche in modifica occorre istanziare un nuovo CivDocumentoPubblicazione se non esistente
                documentoPubblicazione = civDocumentoPubblicazioneService.getOrCreateByUkAttoAndTipoAtto(dettaglio.idAtto, dettaglio.tipoAtto)

                // Rispetto all'inserimento, occorre istanziare un nuovo CivDatiProvenienzaAtto
                datiProvenienza = civDatiProvenienzaAttoService.getOrCreateByUkAtto(dettaglio)

                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1()
                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto2()

                DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)

                if (composizioneTestoAttiva && (statoFrammenti == 2)){
                    caricaFormuleAtto()
                }

                previewModelloIstatOpenOn = dettaglio.hasModelloD3U

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

    CivAttoBaseDomain getAtto(){
        return this.dettaglio
    }

    protected void salvaAtto(Boolean showAlert=Boolean.TRUE, EGestioneConsolidamento gc=null){
        if (dettaglio && saveRecordEnabled) {
            askStoricizzazione({ Boolean hasBeenStoricizzato ->
                CivProcessoVerbale c
                try {
                    c = civProcessoVerbaleService.save(tipoOperazione, dettaglio, null, datiProvenienza, sposi, documentoPubblicazione, mapFormule, gc)
                    if (tipoOperazione.isUpdate() && showAlert && composizioneTestoAttiva) {
                        Messagebox.show(getEtichetta(EtichetteMessaggi.Warn_Aggiornamento_Formule), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    }
                    if (composizioneTestoAttiva && (statoFrammenti == 1)) {
                        statoFrammenti = 2
                    }
                } catch (RuntimeException ex) {
                    if (gc) {
                        civProcessoVerbaleService.ripristina(tipoOperazione, dettaglio, gc)
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

    @Command void onCheckConsolidamento() {
        if (isDaConsolidareOBloccare()){
            if (dettaglio.natura == ENaturaAtto.N){
                annullaAtto()
            } else {
                bloccaAtto()
            }
        }
    }

}
