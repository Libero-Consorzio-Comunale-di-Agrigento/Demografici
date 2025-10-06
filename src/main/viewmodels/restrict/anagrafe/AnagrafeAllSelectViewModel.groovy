package restrict.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdAnagrafe
import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.GsdAnagrafeService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.anagrafe.AnpAnagrafeService
import it.finmatica.de4gsdzk.anagrafe.RicercaIndividuo
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.NoRecordFoundRuntimeException
import it.finmatica.de4gsdzk.errors.TooManyRecordsFoundRuntimeException
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.dao.EmptyResultDataAccessException
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel
import restrict.TraitCancellazioneCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnagrafeAllSelectViewModel extends AbstractSelectViewModel implements TraitCancellazioneCampi {

    final List<ESesso> listaSesso = [null] + ESesso.values().toList()
    final List<ETipoSiNo> listaSoloResidenti = ETipoSiNo.values() + null

    List<GsdAnagrafeBaseDomain> lista = []
    GsdAnagrafeBaseDomain dettaglio

    boolean newSearchOn = true
    RicercaIndividuo ricercaIndividuo

    String cognome
    String nome
    Date dataNascita
    ESesso sesso

    String codiceFiscale

    Boolean checkConiuge
    Boolean soloResidenti
    Boolean anagrafeEstesa

    ETipoSorgenteRicercaSoggetto sorgente = ETipoSorgenteRicercaSoggetto.ANA

    EArchivioSorgenteSoggetto archivio
    List<EArchivioSorgenteSoggetto> listaArchivio = [null, EArchivioSorgenteSoggetto.ANA, EArchivioSorgenteSoggetto.CIV]

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    @WireVariable
    private AnpAnagrafeService anpAnagrafeService

    @WireVariable
    private GsdAnagrafeService gsdAnagrafeService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("cognome") String cognome,
         @ExecutionArgParam("nome") String nome,
         @ExecutionArgParam("dataNascita") Date dataNascita,
         @ExecutionArgParam("sesso") ESesso sesso,
         @ExecutionArgParam("checkConiuge") Boolean checkConiuge,
         @ExecutionArgParam("codiceFiscale") String codiceFiscale,
         @ExecutionArgParam("soloResidenti") Boolean soloResidenti,
         @ExecutionArgParam("anagrafeEstesa") Boolean anagrafeEstesa,
         @ExecutionArgParam("sessoEnabled") Boolean sessoEnabled) {
        self = w

        searchEnabled = false
        addEnabled = false
        modifyEnabled = false

        List<Map> eList = [Etichette.Seleziona_Soggetto, Etichette.Anagrafe_Locale, Etichette.Anagrafe_Gsd, Etichette.ANPR_desc,
                           Etichette.Codice_Fiscale, Etichette.Ricerca_in_ANPR, Etichette.Cancella, Etichette.Comune_Residenza, Etichette.Archivio, Etichette.Tutti]
        // Aggiungo etichette ricerca individuo
        eList.addAll(RicercaIndividuo.etichetteRicercaDesc)
        // Aggiungo etichette per valori campi di ricerca
        eList.addAll([Etichette.Cancella])
        eList.addAll(ESesso.values()*.getEtichettaDesc())
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Errore_Ricerca_ANPR_No_Result, EtichetteMessaggi.Errore_Ricerca_ANPR,
                      EtichetteMessaggi.Errore_Ricerca_ANPR_Soggetto_Non_presente, EtichetteMessaggi.Compilare_campi_ANPR,
                      EtichetteMessaggi.Errore_Ricerca_Archivio_Soggetto])
        eList.addAll(GsdAnagrafeBaseDomain.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        // Aggiungo etichette Archivio
        eList.addAll(EArchivioSorgenteSoggetto.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Seleziona_Soggetto)

        ricercaIndividuo = new RicercaIndividuo()
        ricercaIndividuo.cognome = cognome
        ricercaIndividuo.nome = nome
        ricercaIndividuo.dataNascitaDal = dataNascita
        ricercaIndividuo.dataNascitaAl = dataNascita
        ricercaIndividuo.sesso = sesso
        ricercaIndividuo.codiceFiscale = codiceFiscale
        ricercaIndividuo.sessoEnabled = sessoEnabled ?: false

        this.sesso = sesso
        this.cognome = (cognome?:'')
        this.nome = (nome?:'')
        this.dataNascita = dataNascita
        this.codiceFiscale = codiceFiscale

        this.checkConiuge = checkConiuge
        this.soloResidenti = soloResidenti
        this.anagrafeEstesa = anagrafeEstesa

        totalSizeLabel = ""

        onRicerca()
    }

    @Command
    void onRicerca() {
        if (anagrafeEstesa){
            this.sorgente = ETipoSorgenteRicercaSoggetto.GSD
        } else {
            this.sorgente = ETipoSorgenteRicercaSoggetto.ANA
        }
        resetArchivio()
        onRicarica()
    }

    @Command
    void onRicercaANP() {
        this.sorgente = ETipoSorgenteRicercaSoggetto.ANP
        resetArchivio()
        onRicarica()
    }

    private void resetArchivio() {
        if (sorgente == ETipoSorgenteRicercaSoggetto.GSD) {
            listaArchivio = [null, EArchivioSorgenteSoggetto.ANA, EArchivioSorgenteSoggetto.CIV]
        }
        if (sorgente == ETipoSorgenteRicercaSoggetto.ANA) {
            listaArchivio = [EArchivioSorgenteSoggetto.ANA]
        }
        if (sorgente == ETipoSorgenteRicercaSoggetto.ANP) {
            listaArchivio = [EArchivioSorgenteSoggetto.ANP]
        }
        archivio = archivio in listaArchivio ? archivio : listaArchivio.first()
    }

    void caricaLista() {
        resetRicerca()

        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione<GsdAnagrafeBaseDomain> eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(SortUtils.cognomeNomeNatoAsc))
        Page<?> p
        if (newSearchOn) {
            switch (sorgente) {
                case ETipoSorgenteRicercaSoggetto.ANP:
                    p = anpAnagrafeService.listByRicercaIndividuo(ricercaIndividuo, pr)
                    break
                case ETipoSorgenteRicercaSoggetto.ANA:
                    p = anaAnagrafeService.listAllByRicercaIndividuo(ricercaIndividuo, pr)
                    break
                case ETipoSorgenteRicercaSoggetto.GSD:
                    p = gsdAnagrafeService.listAllByRicercaIndividuo(ricercaIndividuo, pr)
                    break
            }
        } else {
            RicercaSoggetto rs = new RicercaSoggetto(cognome, nome, codiceFiscale, sesso, dataNascita, null, archivio)
            switch (sorgente) {
                case ETipoSorgenteRicercaSoggetto.ANP:
                    p = anpAnagrafeService.list(rs, pr)
                    break
                case ETipoSorgenteRicercaSoggetto.ANA:
                    p = anaAnagrafeService.listAllByRicercaSoggetto(rs, soloResidenti, pr)
                    break
                case ETipoSorgenteRicercaSoggetto.GSD:
                    p = gsdAnagrafeService.listAll(rs, pr)
                    break
            }
        }
        return new Paginazione<GsdAnagrafeBaseDomain>((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    boolean isAnpr() { sorgente == ETipoSorgenteRicercaSoggetto.ANP }

    boolean isGsd() { sorgente == ETipoSorgenteRicercaSoggetto.GSD }

    String getLabelSorgente(){
        switch (sorgente) {
            case ETipoSorgenteRicercaSoggetto.ANP:
                return getEtichetta(Etichette.ANPR_desc)
            case ETipoSorgenteRicercaSoggetto.ANA:
                return getEtichetta(Etichette.Anagrafe_Locale)
            case ETipoSorgenteRicercaSoggetto.GSD:
                return getEtichetta(Etichette.Anagrafe_Gsd)
        }
    }

    @Command onSeleziona() {
        if (dettaglio) {
            if (dettaglio instanceof AnpAnagrafe) {
                try {
                    // faccio partire nuovamente la ricerca per ottenere i dati completi del soggetto e per recupero di eventuale dati coniuge
                    GsdAnagrafeBaseDomain soggettoCompleto = anpAnagrafeService.findBySoggetto(dettaglio)
                    checkAndSelectSoggetto(soggettoCompleto)
                } catch (Exception e) {
                    // non dovrebbe mai accadere
                    log.error(e.message, e)
                    throw e
                }
            } else if (dettaglio instanceof AnaAnagrafe || dettaglio instanceof GsdAnagrafe) {
                String errArchivioSorgente
                switch (dettaglio.archivio) {
                    case EArchivioSorgenteSoggetto.ANA:
                        errArchivioSorgente = 'dell\'Anagrafe Locale'
                        break
                    case EArchivioSorgenteSoggetto.CIV:
                        errArchivioSorgente = 'dell\'Archivio Locale'
                        break
                    default:
                        errArchivioSorgente = 'dell\'Archivio Locale'
                        break
                }
                try {
                    // prendo il soggetto dall'ANPR
                    GsdAnagrafeBaseDomain soggettoAnpr = anpAnagrafeService.findBySoggetto(dettaglio)
                    checkAndSelectSoggetto(soggettoAnpr)
                } catch (CampoMandatoryRuntimeException e) {
                    throw e
                } catch (NoRecordFoundRuntimeException ex) {
                    log.error(ex.message, ex)
                    String errMsg = getEtichetta(EtichetteMessaggi.Errore_Ricerca_ANPR_Soggetto_Non_presente) + "\nVerranno recuperati i dati $errArchivioSorgente"
                    Messagebox.show(errMsg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION, {
                        checkAndSelectSoggetto(dettaglio)
                    })
                } catch (TooManyRecordsFoundRuntimeException ex) {
                    log.error(ex.message, ex)
                    String errMsg = getEtichetta(EtichetteMessaggi.Errore_Ricerca_ANPR) + "\nVerranno recuperati i dati $errArchivioSorgente"
                    Messagebox.show(errMsg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION, {
                        checkAndSelectSoggetto(dettaglio)
                    })
                } catch (Exception ex) {
                    log.error(ex.message, ex)
                    String errMsg = getEtichetta(EtichetteMessaggi.Errore_Ricerca_ANPR) + "\nVerranno recuperati i dati $errArchivioSorgente"
                    Messagebox.show(errMsg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION, {
                        checkAndSelectSoggetto(dettaglio)
                    })
                }
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Nessun_dato_disponibile), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    private void checkAndSelectSoggetto(GsdAnagrafeBaseDomain selected) {
        if ((selected != null) && (sesso != null) && (selected.sesso != null) && (sesso != selected.sesso)) {
            Messagebox.show("Il sesso del soggetto selezionato non risulta coerente con quello indicato fra i parametri di ricerca", msgTitle, Messagebox.OK, Messagebox.ERROR)
            return
        }
        if (selected instanceof AnpAnagrafe) {
            String anomalia = checkCoerenzaAnpr(selected)
            if (anomalia) {
                Messagebox.show(anomalia, msgTitle, Messagebox.OK, Messagebox.ERROR, {
                    selectSoggetto(selected)
                })
                return
            }
        }
        selectSoggetto(selected)
    }

    private String checkCoerenzaAnpr(AnpAnagrafe selected) {
        //Verifico coerenza fra i dati dell'anagrafe locale e quelli di ANPR
        SoggettoAnpr sAnpr = new SoggettoAnpr(selected.cognome, selected.nome, selected.matricola, selected.dataNascita,
                selected.comuneNascita.codice, selected.comuneNascita.codiceProvincia, selected.comuneNascita.descrizione, selected.comuneNascita.siglaProvincia,
                selected.comuneResidenza.codice, selected.comuneResidenza.codiceProvincia, selected.comuneResidenza.descrizione, selected.comuneResidenza.siglaProvincia)
        String anomalia = anaAnagrafeService.checkCoerenzaAnprAnagrafe(sAnpr, selected.anagrafe)

        //Verifico coerenza fra i dati dell'anagrafe locale e quelli di ANPR per il coniuge
        if (checkConiuge && selected.coniuge?.idAnagrafe != null) {
            AnaAnagrafe anaConiuge
            try {
                anaConiuge = anaAnagrafeService.get(selected.coniuge.idAnagrafe, [:])
            } catch (EmptyResultDataAccessException e) {
                log.warn("Errore in recupero matricola coniuge da anagrafe locale con matricola coniuge da ANPR")
                anaConiuge = null
            }
            SoggettoAnpr sConAnpr = new SoggettoAnpr(selected.coniuge.cognome, selected.coniuge.nome, anaConiuge?.matricola, selected.coniuge.dataNascita,
                    selected.coniuge?.comuneNascita?.codice, selected.coniuge?.comuneNascita?.codiceProvincia,
                    selected.coniuge?.comuneNascita?.descrizione, selected.coniuge?.comuneNascita?.siglaProvincia,
                    selected.coniuge?.comuneResidenza?.codice, selected.coniuge?.comuneResidenza?.codiceProvincia,
                    selected.coniuge?.comuneResidenza?.descrizione, selected.coniuge?.comuneResidenza?.siglaProvincia)
            String anomaliaConiuge = anaAnagrafeService.checkCoerenzaAnprAnagrafe(sConAnpr, anaConiuge, "CONIUGE")
            if (anomaliaConiuge) {
                anomalia += anomaliaConiuge
            }
        }
        return anomalia
    }

    private void selectSoggetto(GsdAnagrafeBaseDomain selected) {
        Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, selected)
        onChiudi()
    }

    @Command
    void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricercaIndividuo, p)
        resetRicerca()
    }

    void resetLista(){
        lista = []
        refreshLista()
    }

    @Override
    protected void resetRicerca(){
        resetLista()
        updateTotalSize(0L)
        refreshUi()
    }
}
