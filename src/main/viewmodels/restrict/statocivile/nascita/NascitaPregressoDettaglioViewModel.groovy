package restrict.statocivile.nascita

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.archivi.ArcComune
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
class NascitaPregressoDettaglioViewModel extends NascitaDettaglioParentViewModel{

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivNascitaService civNascitaService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    @WireVariable
    private CivMargineService civMargineService

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
            dettaglio = new CivNascita(partoPlurimo: Boolean.FALSE, natoMorto: EStatoNascita.Nato_vivo, codiceRecord: new Integer(0))
            dettaglio.ufficio = gsdService.getLoggedUserUfficio()

            //Nel caso di inserimento di un pregresso non devo creare il collegamento con CivAnagrafe

            margine = new CivMargine()

            datiProvenienza = new CivDatiProvenienzaAtto()

            mapFormule = [:]

            formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

            CivTipoAtto tipoAttoDomain = params.tipoAttoDomain
            dettaglio.tipoAttoDomain = tipoAttoDomain
            dettaglio.parte = tipoAttoDomain?.parte
            dettaglio.serie = tipoAttoDomain?.serie
            dettaglio.natura = tipoAttoDomain?.natura

            if (dettaglio.isPrimaA() || dettaglio.isPrimaB()) {
                ArcComune comune = gsdService.checkComuneNascitaAuto()
                if (comune) {
                    dettaglio.codiceComuneNascita = comune.codiceComune
                    dettaglio.codiceProvinciaNascita = comune.codiceProvincia
                    dettaglio.descrizioneComuneNascita = comune.descrizioneComune
                    dettaglio.siglaProvinciaNascita = comune.siglaProvincia
                }
            }

            if (dettaglio.isSecondaA()) {
                ArcComune comune = gsdService.checkComuneResidenzaAuto()
                if (comune) {
                    dettaglio.codiceComuneResidenza = comune.codiceComune
                    dettaglio.codiceProvinciaResidenza = comune.codiceProvincia
                    dettaglio.descrizioneComuneResidenza = comune.descrizioneComune
                    dettaglio.siglaProvinciaResidenza = comune.siglaProvincia
                }
            }

            caricaListaSesso()
            // refs #67308
            caricaListaDichiarante()

            caricaListaTipoRichiesta()

        } catch (CompetenzeRuntimeException ex){
            Messagebox.show((getEtichetta(ex.getEtichetta())?:ex.getMessage()), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            onChiudi()
        }
    }

    void caricaDettaglio(def id) {
        if (id) {
            try{
                dettaglio = civNascitaService.get(id, [fetch: [[campo: 'nazionalita', tipo: JoinType.LEFT], [campo: 'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT], [campo: 'motivoNascita', tipo: JoinType.LEFT],
                                                              [campo:'nazionalitaPadre', tipo: JoinType.LEFT], [campo:'nazionalitaMadre', tipo: JoinType.LEFT], [campo:'utenteUpd', tipo: JoinType.LEFT]]])

                tipoOperazione = ETipoOperazione.UPD

                caricaListaFiliazione()

                caricaListaSesso()

                formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

                buttonConsolidamentoLabel = FormUtils.getAttoButtonConsolidamentoLabel(dettaglio, etichette)

                // Per un pregresso non devo salvare su CIVANA

                // Anche in modifica occorre istanziare un nuovo CivMargine se non esitente
                margine = civMargineService.getOrCreateByUkAtto(dettaglio)

                caricaListaSoggettiCollegati()

                // Rispetto all'inserimento, occorre istanziare un nuovo CivDatiProvenienzaAtto senza prevalorizzare alcun attributo
                datiProvenienza = civDatiProvenienzaAttoService.getOrCreateByUkAtto(dettaglio)
                // refs #67308
                caricaListaDichiarante()
                onSelectDichiarante()

                DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)
                DomainUtils.allineaTestoMinuscole(datiProvenienza, minuscole)

                if (composizioneTestoAttiva && (statoFrammenti == 2)){
                    caricaFormuleAtto()
                }

                previewModelloIstatOpenOn = dettaglio.hasModelloP4

                anscEnabled = (anscOn && (dettaglio.numeroUnico != null) )

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

    CivAttoBaseDomain getAtto(){
        return this.dettaglio
    }

    protected void salvaAtto(Boolean showAlert=Boolean.TRUE, EGestioneConsolidamento gc=null){
        if (dettaglio && saveRecordEnabled) {
            askStoricizzazione({ Boolean hasBeenStoricizzato ->
                CivNascita c
                try {
                    c = civNascitaService.save(tipoOperazione, dettaglio, null, datiProvenienza, margine, mapFormule, composizioneTestoAttiva, gc, margineMandatory, listaSoggettiCollegati, false, hasBeenStoricizzato)
                    if (tipoOperazione.isUpdate() && showAlert && composizioneTestoAttiva) {
                        Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Aggiornamento_Formule")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    }
                    if (composizioneTestoAttiva && (statoFrammenti == 1)) {
                        statoFrammenti = 2
                    }
                } catch (RuntimeException ex) {
                    if (gc) {
                        civNascitaService.ripristina(tipoOperazione, dettaglio, gc)
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
