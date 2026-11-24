package restrict.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.AnsAnagrafe
import it.finmatica.de4gsdzk.AnsAnagrafeService
import it.finmatica.de4gsdzk.GsdAnagrafe
import it.finmatica.de4gsdzk.AnagrafeBaseDomain
import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.GsdAnagrafeService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.ansc.*
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
import restrict.TraitInvioComunicazioneAnsc

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnagrafeAllSelectViewModel extends AbstractSelectViewModel implements TraitCancellazioneCampi, TraitInvioComunicazioneAnsc {

    final List<ESesso> listaSesso = [null] + ESesso.values().toList()
    final List<ETipoSiNo> listaSoloResidenti = ETipoSiNo.values() + null

    List<AnagrafeBaseDomain> lista = []
    AnagrafeBaseDomain dettaglio

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
    Boolean inserimentoSoggetto
    Boolean flagInserimento
    ETipoAnagrafe archivioAnagrafe
    ETipoPratica tipoPratica
    Boolean statoCivile

    ETipoSorgenteRicercaSoggetto sorgente = ETipoSorgenteRicercaSoggetto.ANA

    EArchivioSorgenteSoggetto archivio
    List<EArchivioSorgenteSoggetto> listaArchivio = [null, EArchivioSorgenteSoggetto.ANA, EArchivioSorgenteSoggetto.CIV]

    AnscEndPointServizioArchivio servizioRicercaSoggetti

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    @WireVariable
    private AnpAnagrafeService anpAnagrafeService

    @WireVariable
    private GsdAnagrafeService gsdAnagrafeService

    @WireVariable
    private AnsAnagrafeService ansAnagrafeService

    @WireVariable
    private AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    @WireVariable
    private AnscComunicazioneService anscComunicazioneService

    @WireVariable
    private AnscUtenteService anscUtenteService

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
         @ExecutionArgParam("sessoEnabled") Boolean sessoEnabled,
         @ExecutionArgParam("inserimentoSoggetto") Boolean inserimentoSoggetto,
         @ExecutionArgParam("flagInserimento") Boolean flagInserimento,
         @ExecutionArgParam("archivioAnagrafe") ETipoAnagrafe archivioAnagrafe,
         @ExecutionArgParam("tipoPratica") ETipoPratica tipoPratica,
         @ExecutionArgParam("statoCivile") Boolean statoCivile) {
        self = w

        searchEnabled = false
        addEnabled = false
        modifyEnabled = false

        List<Map> eList = [Etichette.getEtichetta("Seleziona_Soggetto"), Etichette.getEtichetta("Anagrafe_Locale"), Etichette.getEtichetta("Anagrafe_Gsd"), Etichette.getEtichetta("ANPR_desc"),
                           Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Ricerca_in_ANPR"), Etichette.getEtichetta("Ricerca_ANSC"), Etichette.getEtichetta("Cancella"), Etichette.getEtichetta("Comune_Residenza"), Etichette.getEtichetta("Archivio"), Etichette.getEtichetta("Tutti")]
        // Aggiungo etichette ricerca individuo
        eList.addAll(RicercaIndividuo.etichetteRicercaDesc)
        eList.addAll([Etichette.getEtichetta("Prosegui")])
        eList.addAll(ESesso.values()*.getEtichettaDesc())
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Errore_Ricerca_ANPR_No_Result"), Etichette.getEtichetta("Errore_Ricerca_ANPR"), Etichette.getEtichetta("Errore_ANSC_servizio_notifica"),
                      Etichette.getEtichetta("Errore_Ricerca_ANPR_Soggetto_Non_presente"), Etichette.getEtichetta("Compilare_campi_ANPR"),
                      Etichette.getEtichetta("Errore_Ricerca_Archivio_Soggetto")])
        eList.addAll(AnagrafeBaseDomain.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        // Aggiungo etichette Archivio
        eList.addAll(EArchivioSorgenteSoggetto.values()*.getEtichettaDesc())
        eList.addAll(Etichette.getEtichetta("Soggetto_Non_Compatibile"))

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Seleziona_Soggetto"))

        ricercaIndividuo = new RicercaIndividuo()
        ricercaIndividuo.cognome = cognome
        ricercaIndividuo.nome = nome
        ricercaIndividuo.dataNascitaDal = dataNascita
        ricercaIndividuo.dataNascitaAl = dataNascita
        ricercaIndividuo.sesso = sesso
        ricercaIndividuo.codiceFiscale = codiceFiscale
        ricercaIndividuo.sessoEnabled = sessoEnabled ?: false
        ricercaIndividuo.ricercaAnsc = anagrafeEstesa ?: false

        if(ricercaIndividuo.ricercaAnsc) {
            servizioRicercaSoggetti =  anscEndPointServizioArchivioService.getServizioArchivioSoggettiRicerca()
        }

        this.sesso = sesso
        this.cognome = (cognome?:'')
        this.nome = (nome?:'')
        this.dataNascita = dataNascita
        this.codiceFiscale = codiceFiscale

        this.checkConiuge = checkConiuge
        this.soloResidenti = soloResidenti
        this.anagrafeEstesa = anagrafeEstesa
        this.inserimentoSoggetto = inserimentoSoggetto ?: false
        this.flagInserimento = flagInserimento ?: false
        this.archivioAnagrafe = archivioAnagrafe
        this.tipoPratica = tipoPratica
        this.statoCivile = statoCivile ?: false

        totalSizeLabel = ""

        if(ricercaIndividuo.cognome != null || ricercaIndividuo.nome != null ||
                ricercaIndividuo.dataNascitaDal != null || ricercaIndividuo.dataNascitaAl != null ||
                ricercaIndividuo.sesso != null || ricercaIndividuo.codiceFiscale != null){
            onRicerca()
        }

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

    @Command
    void onRicercaANSC() {
        this.sorgente = ETipoSorgenteRicercaSoggetto.ANS
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

    Paginazione<AnagrafeBaseDomain> eseguiQuery(Boolean usePaging){
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
                case ETipoSorgenteRicercaSoggetto.ANS:
                    ricercaANSC(ricercaIndividuo)
                    p = ansAnagrafeService.listAllByRicercaIndividuo(ricercaIndividuo, pr)
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
        return new Paginazione<AnagrafeBaseDomain>((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    private void ricercaANSC(RicercaIndividuo ricercaIndividuo) {
        if (servizioRicercaSoggetti?.servizio == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_ANSC_servizio_notifica")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            return
        } else {
            RicercaSoggettoAnsc ricercaSoggetto = new RicercaSoggettoAnsc()
            ricercaSoggetto.nome = ricercaIndividuo.nome
            ricercaSoggetto.cognome = ricercaIndividuo.cognome
            ricercaSoggetto.sesso = ricercaIndividuo.sesso
            ricercaSoggetto.dataNascita = ricercaIndividuo.dataNascitaDal
            verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc.CER, servizioRicercaSoggetti, null, null, ricercaSoggetto, null)
        }
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    boolean isAnpr() { sorgente == ETipoSorgenteRicercaSoggetto.ANP }

    boolean isGsd() { sorgente == ETipoSorgenteRicercaSoggetto.GSD || sorgente == ETipoSorgenteRicercaSoggetto.ANS }

    String getLabelSorgente(){
        switch (sorgente) {
            case ETipoSorgenteRicercaSoggetto.ANP:
                return getEtichetta(Etichette.getEtichetta("ANPR_desc"))
            case ETipoSorgenteRicercaSoggetto.ANA:
                return getEtichetta(Etichette.getEtichetta("Anagrafe_Locale"))
            case ETipoSorgenteRicercaSoggetto.GSD:
                return getEtichetta(Etichette.getEtichetta("Anagrafe_Gsd"))
            case ETipoSorgenteRicercaSoggetto.ANS:
                return getEtichetta(Etichette.getEtichetta("Anagrafe_Gsd"))
        }
    }

    @Command onSeleziona() {
        if (dettaglio) {
            if (dettaglio instanceof AnpAnagrafe) {
                //Controllo DECEDUTO - RESIDENTE nel comune
                try {
                    // faccio partire nuovamente la ricerca per ottenere i dati completi del soggetto e per recupero di eventuale dati coniuge
                    AnagrafeBaseDomain soggettoCompleto = anpAnagrafeService.findBySoggetto(dettaglio)
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
                    AnagrafeBaseDomain soggettoAnpr = anpAnagrafeService.findBySoggetto(dettaglio)
                    checkAndSelectSoggetto(soggettoAnpr)
                } catch (CampoMandatoryRuntimeException e) {
                    throw e
                } catch (NoRecordFoundRuntimeException ex) {
                    log.error(ex.message, ex)
                    String errMsg = getEtichetta(Etichette.getEtichetta("Errore_Ricerca_ANPR_Soggetto_Non_presente")) + "\nVerranno recuperati i dati $errArchivioSorgente"
                    Messagebox.show(errMsg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION, { event ->
                        if (event.name == Messagebox.ON_OK) {
                            checkAndSelectSoggetto(dettaglio)
                        }
                    })
                } catch (TooManyRecordsFoundRuntimeException ex) {
                    log.error(ex.message, ex)
                    String errMsg = getEtichetta(Etichette.getEtichetta("Errore_Ricerca_ANPR")) + "\nVerranno recuperati i dati $errArchivioSorgente"
                    Messagebox.show(errMsg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION, { event ->
                        if (event.name == Messagebox.ON_OK) {
                            checkAndSelectSoggetto(dettaglio)
                        }
                    })
                } catch (Exception ex) {
                    log.error(ex.message, ex)
                    String errMsg = getEtichetta(Etichette.getEtichetta("Errore_Ricerca_ANPR")) + "\nVerranno recuperati i dati $errArchivioSorgente"
                    Messagebox.show(errMsg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION, { event ->
                        if (event.name == Messagebox.ON_OK) {
                            checkAndSelectSoggetto(dettaglio)
                        }
                    })
                }
            } else if (dettaglio instanceof AnsAnagrafe) {
                try {
                    // prendo il soggetto dall'ANPR
                    AnagrafeBaseDomain soggettoAnpr = anpAnagrafeService.findBySoggetto(dettaglio)
                    checkAndSelectSoggetto(soggettoAnpr)
                } catch (CampoMandatoryRuntimeException e) {
                    throw e
                } catch (Exception ex) {
                    log.error(ex.message, ex)
                    checkAndSelectSoggetto(dettaglio)
                }
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    private void checkAndSelectSoggetto(AnagrafeBaseDomain selected) {
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
        String anomalia = anaAnagrafeService.checkCoerenzaAnprAnagrafe(sAnpr, selected.anagrafe, "SOGGETTO", statoCivile)

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
            String anomaliaConiuge = anaAnagrafeService.checkCoerenzaAnprAnagrafe(sConAnpr, anaConiuge, "CONIUGE", statoCivile)
            if (anomaliaConiuge) {
                anomalia += anomaliaConiuge
            }
        }
        return anomalia
    }

    private void selectSoggetto(AnagrafeBaseDomain selected) {
        boolean esito = true
        if (selected && !(selected instanceof GsdAnagrafeBaseDomain) && archivioAnagrafe && tipoPratica) {
            esito = checkSoggettoValidoPerInserimento(selected as AnaAnagrafeBaseDomain)
        }

        if (esito) {
            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, selected)
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Soggetto_Non_Compatibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }


    private boolean checkSoggettoValidoPerInserimento(AnaAnagrafeBaseDomain selected) {
        boolean esito
        switch (tipoPratica) {
            case ETipoPratica.ISC:
                if (archivioAnagrafe == ETipoAnagrafe.RESIDENTI) {
                    esito = selected.flagResInsEnable
                } else { // AIRE
                    esito = selected.flagAirInsEnable
                }
                break
            case ETipoPratica.CANC:
                if (archivioAnagrafe == ETipoAnagrafe.RESIDENTI) {
                    esito = selected.flagResCancEnable
                } else { // AIRE
                    esito = selected.flagAirCancEnable
                }
                break
            case ETipoPratica.VAR:
                if (archivioAnagrafe == ETipoAnagrafe.RESIDENTI) {
                    esito = selected.flagResVarEnable
                } else { // AIRE
                    esito = selected.flagAirVarEnable
                }
                break
            case ETipoPratica.RET:
                if (archivioAnagrafe == ETipoAnagrafe.RESIDENTI) {
                    esito = selected.flagResRetEnable
                } else { // AIRE
                    esito = selected.flagAirRetEnable
                }
                break
        }
        return esito
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

    @Override
    Boolean isInvioServizioDisabled(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc archivioRif, Long idRif) {
        return null
    }

    @Override
    void verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu, Long idRif, Long idComunicazione, IRicercaAnsc r, IAnscPaginazione paginazione) {
        AnscUtente ansUte = anscUtenteService.getAnscUtenteCorrente()
        recuperaCredenzialiEInviaComunicazione(ansUte, taRifCom, servizioCdu, idRif, idComunicazione, r, paginazione)
    }

    @Override
    void inviaComunicazione(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu, AnscCredenziali cre, Long idRif, Long idComunicazione, IRicercaAnsc r, IAnscPaginazione paginazione, Boolean skip) {
        AnscEndPointServizio servizio = servizioCdu?.servizio
        AnscInfoComunicazioneServizio com = anscComunicazioneService.inviaComunicazioneSoggetto(taRifCom, servizio, idRif,cre, r)
        if ((com.getRetVal() ?: "") != "") {
            Messagebox.show(servizio.descrizioneEstesa + " :\n" + com.getRetVal(), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
    }

    @Command
    void onProsegui(){
        selectSoggetto(null)
    }
}
