package restrict.statocivile.matrimonio.matrimonio

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
class DivorzioPregressoDettaglioViewModel extends DivorzioDettaglioParentViewModel{

    @WireVariable
    private CivDivorzioService civDivorzioService

    @WireVariable
    private CivMargineService civMargineService

    @WireVariable
    private CivSposiAttoService civSposiAttoService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoDomain") CivTipoAtto tipoAttoDomain,
               @ExecutionArgParam("composizioneTestoAttiva") Boolean composizioneTestoAttiva) {
        statoFrammenti = 0

        this.composizioneTestoAttiva = composizioneTestoAttiva

        saveRecordEnabled = true
        deleteRecordEnabled = true
        annotazioniEnabled = true

        doInit(w, id, tipoAttoDomain)
    }

    void creaDettaglio(Map params) {
        log.info ("Parametri gestiti: " + params?.size() + ": Funzionalità di inserimento di un pregresso non attiva per i divorzi")
        onChiudi()
    }

    void caricaDettaglio(def id) {
        if (id) {
            try{
                dettaglio = civDivorzioService.get(id, [fetch:[[campo:'nazionalita1', tipo: JoinType.LEFT], [campo:'nazionalita2', tipo: JoinType.LEFT],
                                                               [campo:'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT], [campo:'utenteUpd', tipo: JoinType.LEFT]]])

                tipoOperazione = ETipoOperazione.UPD

                formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

                buttonConsolidamentoLabel = FormUtils.getAttoButtonConsolidamentoLabel(dettaglio, etichette)

                // Per un pregresso non devo salvare su CIVANA

                // Anche in modifica occorre istanziare un nuovo CivMargine se non esitente
                margine = civMargineService.getOrCreateByUkAtto(dettaglio)

                // Anche in modifica occorre istanziare un nuovo CivSposiAtto se non esistente
                sposi = civSposiAttoService.getOrCreateByUkAttoAndTipoAtto(dettaglio.idAtto, dettaglio.tipoAtto)

                // Rispetto all'inserimento, occorre istanziare un nuovo CivDatiProvenienzaAtto
                datiProvenienza = civDatiProvenienzaAttoService.getOrCreateByUkAtto(dettaglio)

                caricaListaTipiDivorzioAltro()

                caricaListaDichiarante()
                onSelectDichiarante()

                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1()
                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto2()

                DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)
                DomainUtils.allineaTestoMinuscole(datiProvenienza, minuscole)

                if (composizioneTestoAttiva && (statoFrammenti == 2)){
                    caricaFormuleAtto()
                }

                previewModelloIstatOpenOn = (dettaglio.hasModelloSC || dettaglio.hasModelloSDSU)

                anscEnabled = (anscOn && (dettaglio.numeroUnico != null) )

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
                CivMatrimonio c
                try {
                    c = civDivorzioService.save(tipoOperazione, dettaglio, null, datiProvenienza, margine, sposi, mapFormule, null, gc, margineMandatory, hasBeenStoricizzato)
                    if (tipoOperazione.isUpdate() && showAlert && composizioneTestoAttiva) {
                        Messagebox.show(getEtichetta(EtichetteMessaggi.Warn_Aggiornamento_Formule), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    }
                    if (composizioneTestoAttiva && (statoFrammenti == 1)) {
                        statoFrammenti = 2
                    }
                } catch (RuntimeException ex) {
                    if (gc) {
                        civDivorzioService.ripristina(tipoOperazione, dettaglio, gc)
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
