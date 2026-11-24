package restrict.statocivile.matrimonio.matrimonio

import it.finmatica.de4gsdzk.utils.Etichette
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
class MatrimonioPregressoDettaglioViewModel extends MatrimonioDettaglioParentViewModel{

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivMatrimonioService civMatrimonioService

    @WireVariable
    private CivMargineService civMargineService

    @WireVariable
    private CivSposiAttoService civSposiAttoService

    @WireVariable
    private CivTestimoniAttoService civTestimoniAttoService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoDomain") CivTipoAtto tipoAttoDomain,
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
            dettaglio = new CivMatrimonio(codiceRecord: new Integer(0))
            dettaglio.ufficio = gsdService.getLoggedUserUfficio()

            //Nel caso di inserimento di un pregresso non devo creare il collegamento con CivAnagrafe

            margine = new CivMargine(documentoPresentatoMatrimonio: EDocumentoMatrimonio.ALT)

            sposi = new CivSposiAtto()

            mapFormule = [:]

            formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

            CivTipoAtto tipoAttoDomain = params.tipoAttoDomain
            dettaglio.tipoAttoDomain = tipoAttoDomain
            dettaglio.parte = tipoAttoDomain?.parte
            dettaglio.serie = tipoAttoDomain?.serie
            dettaglio.natura = tipoAttoDomain?.natura

            datiProvenienza = new CivDatiProvenienzaAtto()
            if (dettaglio.isFuoriCasaComunale() || dettaglio.isPericoloVita()){
                datiProvenienza.flagCasaComunale = Boolean.FALSE
            }

            if ( dettaglio.isTestimoniVisibile() ){
                Integer numTestimoni = (dettaglio.isTestimoniMandatory()?new Integer(2):null)
                testimoni = civTestimoniAttoService.create(numTestimoni)
            }

            caricaListaDichiarante()

            setComuneMatrimonioAuto()

        } catch (CompetenzeRuntimeException ex){
            Messagebox.show((getEtichetta(ex.getEtichetta())?:ex.getMessage()), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            onChiudi()
        }
    }

    void caricaDettaglio(def id) {
        if (id) {
            try{
                dettaglio = civMatrimonioService.get(id, [fetch:[[campo:'nazionalita1', tipo: JoinType.LEFT], [campo:'nazionalita2', tipo: JoinType.LEFT],
                                                                 [campo:'comprensione1', tipo: JoinType.LEFT], [campo:'comprensione2', tipo: JoinType.LEFT],
                                                                 [campo:'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT],[campo:'utenteUpd', tipo: JoinType.LEFT]]])

                tipoOperazione = ETipoOperazione.UPD

                formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

                buttonConsolidamentoLabel = FormUtils.getAttoButtonConsolidamentoLabel(dettaglio, etichette)

                // Per un pregresso non devo salvare su CIVANA

                // Anche in modifica occorre istanziare un nuovo CivMargine se non esitente
                margine = civMargineService.getOrCreateByUkAtto(dettaglio)
                if (margine.documentoPresentatoMatrimonio == null){
                    // #62031
                    margine.documentoPresentatoMatrimonio = EDocumentoMatrimonio.ALT
                }

                // Anche in modifica occorre istanziare un nuovo CivSposiAtto se non esistente
                sposi = civSposiAttoService.getOrCreateByUkAttoAndTipoAtto(dettaglio.idAtto, dettaglio.tipoAtto)

                if ( dettaglio.isTestimoniVisibile() ){
                    // Anche in modifica occorre istanziare un nuovo CivTestimoniAtto se non esistente
                    testimoni = civTestimoniAttoService.getOrCreateByUkAtto(dettaglio, dettaglio.tipoAtto)
                    DomainUtils.allineaTestoMinuscole(testimoni, minuscole)
                }

                caricaListaSoggettiCollegati()

                // Rispetto all'inserimento, occorre istanziare un nuovo CivDatiProvenienzaAtto
                datiProvenienza = civDatiProvenienzaAttoService.getOrCreateByUkAtto(dettaglio)
                if (dettaglio.isFuoriCasaComunale() || dettaglio.isPericoloVita()){
                    datiProvenienza.flagCasaComunale = Boolean.FALSE
                }
                caricaListaDichiarante()
                onSelectDichiarante()

                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1()
                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto2()

                DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)
                DomainUtils.allineaTestoMinuscole(datiProvenienza, minuscole)

                if (composizioneTestoAttiva && (statoFrammenti == 2)){
                    caricaFormuleAtto()
                }

                previewModelloIstatOpenOn = dettaglio.hasModelloD3

                anscEnabled = (anscOn && (dettaglio.numeroUnico != null) )

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

    CivAttoBaseDomain getAtto(){
        return this.dettaglio
    }

    protected void salvaAtto(Boolean showAlert=Boolean.TRUE, EGestioneConsolidamento gc=null){
        if (dettaglio && saveRecordEnabled) {
            askStoricizzazione({ Boolean hasBeenStoricizzato ->
                CivMatrimonio c
                try {
                    c = civMatrimonioService.save(tipoOperazione, dettaglio, null, datiProvenienza, margine, sposi, testimoni, mapFormule, null, gc, margineMandatory, listaSoggettiCollegati, hasBeenStoricizzato)
                    if (tipoOperazione.isUpdate() && showAlert && composizioneTestoAttiva) {
                        Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Aggiornamento_Formule")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    }
                    if (composizioneTestoAttiva && (statoFrammenti == 1)) {
                        statoFrammenti = 2
                    }
                } catch (RuntimeException ex) {
                    if (gc) {
                        civMatrimonioService.ripristina(tipoOperazione, dettaglio, gc)
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
