package restrict.statocivile.nascita

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
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
class NascitaDettaglioViewModel extends NascitaDettaglioParentViewModel{

    ETipoSiNo numeraAtto

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivNascitaService civNascitaService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    @WireVariable
    private CivAnagrafeService civAnagrafeService

    @WireVariable
    private CivMargineService civMargineService

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

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
            dettaglio = new CivNascita(anno: Calendar.getInstance().get(Calendar.YEAR), partoPlurimo: Boolean.FALSE, natoMorto: EStatoNascita.Nato_vivo,
                    codiceRecord: new Integer(3), certificabile: ETipoSiNo.NO)
            dettaglio.ufficio = gsdService.getLoggedUserUfficio()

            anagrafe = new CivAnagrafe()

            margine = new CivMargine()

            mapFormule = [:]

            formLabel = FormUtils.getAttoFormLabel(tipoOperazione, dettaglio, etichette)

            CivTipoAtto tipoAttoDomain = (CivTipoAtto) params.tipoAttoDomain
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
            if ( dettaglio.isCodRec3() && (dettaglio.isDicCompFirmNasVisibile() || dettaglio.isDicCompFirmRicVisibile() ) ) {
                datiProvenienza.comprensioneDichiarante = getDefaultComprensione()
            }
            if (dettaglio.isCodRec3() && (dettaglio.isTrascrizioneEsteroDaAutorita() || dettaglio.isTrascrizioneEsteroDaPrivato()) ){
                datiProvenienza.dichiarazioneGiudiziale = ETipoSiNo.NO
            }

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

                numeraAtto = (dettaglio.isProvvisorio()?ETipoSiNo.NO:ETipoSiNo.SI)

                tipoOperazione = ETipoOperazione.UPD

                caricaListaFiliazione()

                caricaListaSesso()

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

                // Rispetto all'inserimento, occorre istanziare un nuovo CivDatiProvenienzaAtto senza prevalorizzare alcun attributo relativo alla redazione
                datiProvenienza = civDatiProvenienzaAttoService.getOrCreateByUkAtto(dettaglio)
                // Solo per atti in cod_rec 3
                if ( dettaglio.isCodRec3() && (dettaglio.isDicCompFirmNasVisibile() || dettaglio.isDicCompFirmRicVisibile() ) && (datiProvenienza.comprensioneDichiarante == null) ){
                    datiProvenienza.comprensioneDichiarante = getDefaultComprensione()
                }
                // refs #67308
                caricaListaDichiarante()
                onSelectDichiarante()

                DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)
                DomainUtils.allineaTestoMinuscole(datiProvenienza, minuscole)
                
                caricaFormuleAtto()

                previewModelloIstatOpenOn = dettaglio.hasModelloP4

                anscEnabled = (anscOn && dettaglio.isCodRec0() && (dettaglio.numeroUnico != null) )

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
            if ( (!gc) && dettaglio.tipoFiliazione?.equals(ETipoFiliazione.L)
                    && ((anagrafe?.anagrafe2?.id != anagrafe?.anagrafe1?.coniuge?.idAnagrafe) || (anagrafe?.anagrafe2?.coniuge?.idAnagrafe != anagrafe?.anagrafe1?.id))) {
                Integer codRec = (tipoOperazione.isInsert()?dettaglio.codiceRecord:civNascitaService.getCodiceRecord(dettaglio.id))
                if (codRec.intValue() == 3){
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_stato_civile_genitori")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                } else {
                    log.info("Stato anagrafico genitori da non verificare per gli atti consolidati")
                }
            }
            askStoricizzazione({ Boolean hasBeenStoricizzato ->
                CivNascita c
                try {
                    c = civNascitaService.save(tipoOperazione, dettaglio, anagrafe, datiProvenienza, margine, mapFormule, Boolean.TRUE, gc, margineMandatory, listaSoggettiCollegati, false, hasBeenStoricizzato)
                    if (tipoOperazione.isUpdate() && showAlert && (statoFrammenti == 2)) {
                        Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Aggiornamento_Formule")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    }
                    if (statoFrammenti == 1) {
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

    CivAttoBaseDomain getAtto(){
        return this.dettaglio
    }

    @Command void onCheckConsolidamento() {
        if (isDaConsolidareOBloccare()) {
            if (dettaglio.natura == ENaturaAtto.N){
                annullaAtto()
            } else {
                Integer codRec = civNascitaService.getCodiceRecord(dettaglio.id)
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

        if (anagrafe){
            try{
                List<AnaAnagrafe> ll = (anaAnagrafeService.listXDatiAnagrafici(dettaglio)?:[])
                if (ll.size() > 0){
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Inserimento_In_Anagrafe")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    civAnagrafeService.selectAndDelete(anagrafe)
                }
            } finally {
                if (!anscOn){
                    onChiudi()
                }
            }
        } else {
            if (!anscOn){
                onChiudi()
            }
        }
    }

    @Command void onSelectDataNascita(){
        super.onSelectDataNascita()
        if (DataUtils.isDataNascitaIncompatibileInPrimaA(dettaglio)){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_data_nascita_vs_1A")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
        if (DataUtils.isDataNascitaIncompatibileInPrimaB(dettaglio)){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_data_nascita_vs_1B")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
