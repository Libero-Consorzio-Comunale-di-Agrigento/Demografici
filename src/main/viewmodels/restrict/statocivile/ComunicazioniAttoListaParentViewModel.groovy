package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiFascicoloRuntimeException
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.export.JasperExporter
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarComunicazioniAttributes
import it.finmatica.gestionetesti.GestioneTestiService
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import net.sf.jasperreports.engine.JREmptyDataSource
import org.springframework.dao.EmptyResultDataAccessException
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.util.media.Media
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import java.nio.charset.StandardCharsets

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class ComunicazioniAttoListaParentViewModel extends RiferimentiAttoListaParentViewModel{

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    List<CivArchivioComunicazione> lista
    List<CivArchivioComunicazione> listaComunicazioniSelezionate
    CivArchivioComunicazione _dettaglio
    CivComunicazioneProtocollo comunicazioneProtocollo
    List<CivComunicazioneDestinatario> listaDestinatari
    List<Map> listaAllegati

    Boolean massiveCheck
    Boolean showDetailsComunicazione = Boolean.FALSE
    Boolean showDetailsAtto = Boolean.FALSE
    Boolean showMassiveCheck = Boolean.TRUE
    Boolean showDeleteOption = Boolean.TRUE
    Boolean showRecapMessage = Boolean.TRUE

    String managePrincipale

    @Delegate
    ControlBarComunicazioniAttributes cbComList = new ControlBarComunicazioniAttributes()

    @WireVariable
    private CivArchivioComunicazioneService civArchivioComunicazioneService

    @WireVariable
    private CivComunicazioneProtocolloService civComunicazioneProtocolloService

    @WireVariable
    private CivComunicazioneDestinatarioService civComunicazioneDestinatarioService

    @WireVariable
    private CivComunicazioneAllegatoService civComunicazioneAllegatoService

    @WireVariable
    private CivComunicazioneAttoService civComunicazioneAttoService

    @WireVariable
    private CivComunicazioneFormulaService civComunicazioneFormulaService

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private GestioneTestiService gestioneTestiService

    @WireVariable
    private GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    @WireVariable
    private GsdFirmaService gsdFirmaService

    @WireVariable
    private StampaAttoService stampaAttoService

    @WireVariable
    private ArcParametroService arcParametroService

    void caricaManagePrincipale(){
        managePrincipale = arcParametroService.isModificaAllegatoPrincipaleComunicazioneAttiva()
    }

    CivArchivioComunicazione getDettaglio(){
        return _dettaglio
    }

    void setDettaglio(CivArchivioComunicazione arcCom){
        _dettaglio = arcCom

        caricaComunicazioneProtocollo(arcCom?.id)
        caricaDestinatari(arcCom)
        caricaAllegati(arcCom)

        BindUtils.postNotifyChange(null, null, this, "dettaglio")
    }

    void resetDettaglio(){
        setDettaglio(null)
    }

    private void caricaComunicazione(Long id){
        if (id){
            for (CivArchivioComunicazione c : lista){
                if (c.id.compareTo(id) == 0){
                    setDettaglio(c)
                    break
                }
            }
        } else {
            resetDettaglio()
        }
    }

    boolean getLoadOnCloseData(){
        return false
    }

    void setAttributiElaborazione(){
        sendAlboComunicazioneEnabled = false
        protocollaComunicazioneEnabled = false
        for (CivArchivioComunicazione c:lista){
            if ( (tipoAttoEnum == ETipoAtto.PUB) && c.isDaInviareAlbo()){
                sendAlboComunicazioneEnabled = true
            }
            if (c.isDaProtocollare()){
                protocollaComunicazioneEnabled = true
            }
        }
    }

    @Command void onSelezionaTutte() {
        for (CivArchivioComunicazione c: lista){
            if (massiveCheck && c.protocollato){
                continue
            }
            seleziona(massiveCheck, c)
        }
        refreshUi()
    }

    @Command void onSelezionaComunicazione(@BindingParam("selected") Boolean selected, @BindingParam("comunicazione") CivArchivioComunicazione arcCom) {
        seleziona(selected, arcCom, Boolean.TRUE)
    }

    void seleziona(Boolean selected, CivArchivioComunicazione arcCom, Boolean updateDettaglio=false) {
        if (selected){
            if ( !(isSelezionata(arcCom)) ){
                listaComunicazioniSelezionate.add(arcCom)
                if (updateDettaglio){
                    setDettaglio(arcCom)
                }
            }
        } else {
            if ( isSelezionata(arcCom) ){
                listaComunicazioniSelezionate.remove(arcCom)
            }
        }
        BindUtils.postNotifyChange(null, null, this, "listaComunicazioniSelezionate")
    }

    Boolean isSelezionata(CivArchivioComunicazione arcCom){
        for (CivArchivioComunicazione c : listaComunicazioniSelezionate){
            if (c.id.compareTo(arcCom.id) == 0){
                return Boolean.TRUE
            }
        }
        return Boolean.FALSE
    }

    @Command void onEliminaComunicazione(@BindingParam("comunicazione") CivArchivioComunicazione arcCom) {
        if (arcCom?.comunicazione && showDeleteOption){
            Messagebox.show(arcCom.comunicazione.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (Messagebox.ON_OK.equals(e.getName())){
                                eliminaERicaricaComunicazione(arcCom)
                            }
                        }
                    }
            )
        }
    }

    void eliminaERicaricaComunicazione(CivArchivioComunicazione arcCom){
        civComunicazioneAllegatoService.deleteComunicazioneEAllegati(arcCom)
        onRicarica()
    }

    IDaFascicolare getTipologiaComunicazione(CivArchivioComunicazione c){
        ETipoComunicazione tipoComunicazione = c.comunicazione.tipoComunicazione
        // "Atto"
        if (tipoComunicazione == ETipoComunicazione.A){
            return civComunicazioneAttoService.getByUk(tipoAttoEnum, c.comunicazione.id)
        }
        // "Annotazione"
        if (tipoComunicazione == ETipoComunicazione.N){
            return civComunicazioneFormulaService.getByUk(c.formulaDfa.id, c.comunicazione.id)
        }
        return null
    }

    boolean isListaComunicazioniSelezionateEmpty(){
        if (listaComunicazioniSelezionate.size() == 0){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Warn_Nessuna_comunicazione_selezionata), msgTitle, Messagebox.OK, Messagebox.ERROR)
            return true
        }
        return false
    }

    boolean isListaComunicazioniDaElaborareEmpty(List<CivArchivioComunicazione> listaComunicazioniDaElaborare, ETipoElaborazioneComunicazione tipoElaborazione){
        if (listaComunicazioniDaElaborare.size() == 0){
            String errorMsg
            if (tipoElaborazione == ETipoElaborazioneComunicazione.PROTOCOLLAZIONE){
                errorMsg = getEtichetta(EtichetteMessaggi.Warn_Nessuna_comunicazione_da_protocollare)
            } else {
                errorMsg = getEtichetta(EtichetteMessaggi.Warn_Nessuna_comunicazione_da_inviare_albo)
            }
            Messagebox.show(errorMsg, msgTitle, Messagebox.OK, Messagebox.ERROR)
            return true
        }
        return false
    }

    @Command void onFascicolaComunicazione(@BindingParam("arcCom") CivArchivioComunicazione arcCom) {
        if (arcCom) {
            fascicolaComunicazioneEAllegati(arcCom, Boolean.TRUE)
        }
    }

    void fascicolaComunicazioneEAllegati(CivArchivioComunicazione arcCom, Boolean refreshComunicazione=Boolean.FALSE){
        IDaFascicolare df = getTipologiaComunicazione(arcCom)
        int retVal = -1
        try{
            retVal = civComunicazioneAllegatoService.fascicolaComunicazioneEAllegati(arcCom, df)
        } catch (ErroreDatiFascicoloRuntimeException dfre) {
            Messagebox.show(arcCom.comunicazione.descrizione + "\n" + getEtichetta(dfre.getEtichetta()), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            return
        }
        if (refreshComunicazione){
            if (retVal == 0) {
                Messagebox.show(arcCom.comunicazione.descrizione + ":\n" + "non risultano allegati da inserire nel fascicolo dell'atto", msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            } else if (retVal > 0) {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                onPagina()
                caricaComunicazione(arcCom.id)
            } else {
                Messagebox.show(arcCom.comunicazione.descrizione + "\n" + getEtichetta(EtichetteMessaggi.Warn_comunicazione_fascicolata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onGeneraTesti() {
        if (isListaComunicazioniSelezionateEmpty())
            return

        for (CivArchivioComunicazione c : listaComunicazioniSelezionate) {
            if (c.isProtocollato() || c.isInviatoAlbo()){
                String msg = (c.protocollato?getEtichetta(EtichetteMessaggi.Errore_esecuzione_comunicazioni_protocollate):getEtichetta(EtichetteMessaggi.Errore_esecuzione_comunicazioni_inviate_albo))
                Messagebox.show(c.comunicazione.descrizione + ":\n" + msg, msgTitle, Messagebox.OK, Messagebox.ERROR)
            } else {
                Boolean hasPrincipale = civArchivioComunicazioneService.checkAllegatoPrincipale(c.id)
                if (hasPrincipale){
                    Window w = (Window) Executions.createComponents("/restrict/statocivile/customMessagebox.zul", self, [titolo: getEtichetta(Etichette.Comunicazioni),
                                                                                                                         msg: (c.comunicazione.descrizione + ":\n" +  getEtichetta(EtichetteMessaggi.Ask_Aggiornamento_Testo_Comunicazione) ),
                                                                                                                         listaOpzioni:[Etichette.SI, Etichette.NO], params: [arcCom: c]])
                    w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                        if (event.data.opzione.codice == Etichette.SI.codice){
                            generaTestoComunicazione(event.data.params.arcCom)
                        }
                    })
                    w.doModal()
                } else {
                    generaTestoComunicazione(c)
                }
            }
        }
    }

    void generaTestoComunicazione(CivArchivioComunicazione c){
        CivComunicazioneAllegato alleCom = (civComunicazioneAllegatoService.getPrincipale(c.id)?:new CivComunicazioneAllegato(archivioComunicazione:c, principale: Boolean.TRUE))

        ETipoComunicazione tipoComunicazione = c.comunicazione.tipoComunicazione
        IDaFascicolare df = getTipologiaComunicazione(c)

        // genero la stampa e faccio download
        try {
            Map<?, ?> parametriQuery =  [:] // al momento vuoto, i parametri vengono caricati al volo
            GestioneTestiGsdModello g
            if (tipoComunicazione == ETipoComunicazione.A){
                g = gestioneTestiModelloRelazioneService.getByIdComunicazioneAtto(((CivComunicazioneAtto)df).id)?.modello
            }
            if (tipoComunicazione == ETipoComunicazione.N){
                g = gestioneTestiModelloRelazioneService.getByIdComunicazione(((CivComunicazioneFormula)df).comunicazione.id)?.modello
            }
            if (g == null){
                Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Errore_modello_testo_non_trovato), msgTitle, Messagebox.OK, Messagebox.ERROR)
                return
            }
            log.info("Avvio recupero xml data per comunicazione ${c.id}")
            String queryModello = statoCivileService.getDataSourceXmlComunicazione(c)
            log.info("Recuperato xml data per comunicazione ${c.id}")
            String formato = (g.formatoTesto?.name()?:g.tipo).toLowerCase()
            alleCom.nomeAllegato = "${c.nomeFileComunicazione}_${c.idAtto}.${formato}"
            ByteArrayInputStream bais = new ByteArrayInputStream(g.fileTemplate)
            InputStream is = gestioneTestiService.stampaUnione(bais, queryModello, parametriQuery, formato, true)
            salvaAllegato(alleCom, Boolean.TRUE, is, Boolean.TRUE, Boolean.TRUE, Boolean.TRUE)
        } catch (Exception ex){
            log.error("Errore stampa comunicazione", ex)
            String msg = getEtichetta(EtichetteMessaggi.Errore_generazione_testo)
            if (ex instanceof De4gsdzkRuntimeException){
                msg = ex.message
            }
            Messagebox.show(c.comunicazione.descrizione + ":\n" +  msg, msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        refreshLista()
    }

    void salvaAllegato(CivComunicazioneAllegato alleCom, Boolean salvaSuDocumentale, InputStream is,
                       Boolean ignoreStampaEseguita=Boolean.FALSE, Boolean aggiornaStampaEseguita=Boolean.FALSE, Boolean scaricaAllegato=Boolean.FALSE){
        try {
            civComunicazioneAllegatoService.save(alleCom, salvaSuDocumentale, is, Boolean.FALSE, ignoreStampaEseguita, aggiornaStampaEseguita)
            if (scaricaAllegato){
                onDownloadAllegato([id: alleCom.id])
            }
            if (alleCom.archivioComunicazione) {
                if (alleCom.archivioComunicazione.isDaProtocollare() || alleCom.archivioComunicazione.isDaInviareAlbo()) {
                    log.info(alleCom.archivioComunicazione.id + ": non aggiorno il flag stampa_eseguita in quanto comunicazione da protocollare o inviare all'albo")
                } else {
                    for (CivArchivioComunicazione c : lista){
                        if (c.id.compareTo(alleCom.archivioComunicazione.id) == 0){
                            c.stampaEseguita = civArchivioComunicazioneService.get(alleCom.archivioComunicazione.id).stampaEseguita
                            break
                        }
                    }
                }
            }
            caricaAllegati(alleCom.archivioComunicazione)
            refreshLista()
        } catch(DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)
            Messagebox.show(alleCom.nome + ":\n" + (getEtichetta(EtichetteMessaggi.Errore_salvataggio_file_documentale)?:dre.getMessage()) + "\n" + getEtichetta(EtichetteMessaggi.Ask_Conferma_Salvataggio_Documento),
                    msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (Messagebox.ON_OK.equals(e.getName())){
                                alleCom.blobAllegato = is.getBytes()
                                salvaAllegato(alleCom, Boolean.FALSE, is, ignoreStampaEseguita, aggiornaStampaEseguita, scaricaAllegato)
                            }
                        }
                    }
            )
        }
    }

    @Command void onProtocolla() {
        if (isListaComunicazioniSelezionateEmpty())
            return

        List<CivArchivioComunicazione> comunicazioniDaElaborare = []
        for (CivArchivioComunicazione c: listaComunicazioniSelezionate){
            if (c.atto.compareTo(new Integer(0)) < 0){
                Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Errore_protocollazione_comunicazioni_provvisorie), msgTitle, Messagebox.OK, Messagebox.ERROR)
                continue
            }
            if (c.protocollato){
                Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Errore_esecuzione_comunicazioni_protocollate), msgTitle, Messagebox.OK, Messagebox.ERROR)
            } else {
                if (c.isDaProtocollare()){
                    comunicazioniDaElaborare.add(c)
                }
            }
            // Se non è protocollata o da protocollare salto anche se selezionata
        }
        checkFirmaComunicazioni(comunicazioniDaElaborare, ETipoElaborazioneComunicazione.PROTOCOLLAZIONE)
    }

    @Command void onInviaAlbo() {
        if (tipoAttoEnum == ETipoAtto.PUB){
            if (isListaComunicazioniSelezionateEmpty())
                return

            List<CivArchivioComunicazione> comunicazioniDaElaborare = []
            for (CivArchivioComunicazione c: listaComunicazioniSelezionate){
                if (c.atto.compareTo(new Integer(0)) < 0){
                    Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Errore_protocollazione_comunicazioni_provvisorie), msgTitle, Messagebox.OK, Messagebox.ERROR)
                    continue
                }
                if (c.inviatoAlbo){
                    Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Errore_esecuzione_comunicazioni_inviate_albo), msgTitle, Messagebox.OK, Messagebox.ERROR)
                } else {
                    if (c.isDaInviareAlbo()){
                        comunicazioniDaElaborare.add(c)
                    }
                }
                // Se non è da inviare all'albo o già inviata salto anche se selezionata
            }
            checkFirmaComunicazioni(comunicazioniDaElaborare, ETipoElaborazioneComunicazione.INVIO_ALBO)
        }
    }

    void checkFirmaComunicazioni(List<CivArchivioComunicazione> listaComunicazioniDaElaborare, ETipoElaborazioneComunicazione tipoElaborazione){
        if (isListaComunicazioniDaElaborareEmpty(listaComunicazioniDaElaborare, tipoElaborazione))
            return

        //Verifico se devo firmare
        Boolean daFirmare = civComunicazioneAllegatoService.checkAllegatiDaFirmare(listaComunicazioniDaElaborare*.id)
        if (daFirmare){
            Boolean firmaRemotaAutomatica = arcParametroService.isFirmaRemotaAutomaticaAttiva()
            if (firmaRemotaAutomatica){
                firma(listaComunicazioniDaElaborare, null, null, tipoElaborazione)
            } else {
                Window w = (Window) Executions.createComponents("/restrict/statocivile/otp.zul", self, [:])
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data.codUtentefirmatario && event.data.otp){
                        firma(listaComunicazioniDaElaborare, event.data.codUtentefirmatario, event.data.otp, tipoElaborazione)
                    }
                })
                w.doModal()
            }
        } else {
            protocollaOInvia(listaComunicazioniDaElaborare, tipoElaborazione)
        }
    }

    void firma(List<CivArchivioComunicazione> listaComunicazioniDaFirmare, String utente, String otp, ETipoElaborazioneComunicazione tipoElaborazione){
        StringBuilder ids = new StringBuilder("")
        List<CivArchivioComunicazione> listaComunicazioniDaElaborare = []

        for (CivArchivioComunicazione c: listaComunicazioniDaFirmare){
            if (c.isDaProtocollare() || c.isDaInviareAlbo()){
                Boolean hasPrincipale = civArchivioComunicazioneService.checkAllegatoPrincipale(c.id)
                if (hasPrincipale){
                    ids.append(c.id.toString())
                    ids.append(TestoUtils.cancelletto)
                    listaComunicazioniDaElaborare.add(c)
                } else {
                    Messagebox.show(c.comunicazione.descrizione + ":\n" +  getEtichetta(EtichetteMessaggi.Errore_testo_principale_comunicazione), msgTitle, Messagebox.OK, Messagebox.ERROR)
                }
            }
        }

        if (ids.toString() != ""){
            String retVal = civArchivioComunicazioneService.firmaComunicazione(listaComunicazioniDaElaborare, ids.toString(), null, utente, otp)
            if ( (retVal?:"") == ""){
                protocollaOInvia(listaComunicazioniDaElaborare, tipoElaborazione)
            } else {
                Messagebox.show(retVal, getEtichetta(Etichette.Comunicazioni), Messagebox.OK, Messagebox.ERROR)
                for (CivArchivioComunicazione c: listaComunicazioniDaFirmare){
                    if (c.isDaProtocollare() || c.isDaInviareAlbo()){
                        caricaAllegati(c)
                    }
                }
            }
        }
    }

    void protocollaOInvia(List<CivArchivioComunicazione> listaComunicazioniDaElaborare, ETipoElaborazioneComunicazione tipoElaborazione){
        if (isListaComunicazioniDaElaborareEmpty(listaComunicazioniDaElaborare, tipoElaborazione))
            return

        Boolean almenoUnaElaborata = Boolean.FALSE
        String recapMsg = ""
        for (CivArchivioComunicazione c: listaComunicazioniDaElaborare){
            if (c.isDaProtocollare() || c.isDaInviareAlbo()){
                try {
                    String retVal
                    if ((tipoElaborazione == ETipoElaborazioneComunicazione.PROTOCOLLAZIONE) && c.isDaProtocollare()){
                        retVal = civArchivioComunicazioneService.protocolla(c)
                    } else
                    if ((tipoElaborazione == ETipoElaborazioneComunicazione.INVIO_ALBO) && c.isDaInviareAlbo()){
                        retVal = civArchivioComunicazioneService.inviaAlbo(c)
                    } else {
                        continue
                    }
                    if ((retVal ?: "") == "") {
                        almenoUnaElaborata = Boolean.TRUE
                        recapMsg = addToRecapMsg(recapMsg, tipoElaborazione, c)
                        // Per quanto riguarda le comunicazioni da inviare all'albo, adottiamo lo stesso comportamento e quindi fascicoliamo dopo l'invio
                        // o mediante click su apposito pulsante, anche se in teoria nel fascicolo andrebbero dopo la pubblicazione
                        fascicolaComunicazioneEAllegati(c)
                    } else {
                        String preErrMsg = getDettaglioComunicazioneRecapMsg(c)
                        Messagebox.show(preErrMsg + retVal, msgTitle, Messagebox.OK, Messagebox.ERROR)
                    }
                } catch (FileNonValidoRuntimeException fnv){
                    String preErrMsg = getDettaglioComunicazioneRecapMsg(c)
                    Messagebox.show(preErrMsg + (getEtichetta(fnv.getEtichetta())?:fnv.getMessage()), msgTitle, Messagebox.OK, Messagebox.ERROR)
                }
            }
        }
        if (almenoUnaElaborata){
            caricaLista()
            if (showRecapMessage){
                Messagebox.show(getEtichetta(Etichette.RIEPILOGO_ELABORAZIONE) + "\n\n" + recapMsg, msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
        }
    }

    protected String getDettaglioComunicazioneRecapMsg(CivArchivioComunicazione arcCom){
        String msg = arcCom.comunicazione.descrizione + ":\n"
        if (showRecapMessage){
            msg += "  " + getNominativoAtto(arcCom) + "\n"
        }
        return msg
    }

    protected String addToRecapMsg(String initStr, ETipoElaborazioneComunicazione tipoElaborazione, CivArchivioComunicazione arcCom){
        if (showRecapMessage) {
            CivComunicazioneProtocollo comProt = (arcCom.id ? civComunicazioneProtocolloService.get(arcCom.id) : null)
            String msg = arcCom.comunicazione.descrizione + ":\n"
            msg += "  " + getNominativoAtto(arcCom) + "\n"
            msg += (tipoElaborazione == ETipoElaborazioneComunicazione.PROTOCOLLAZIONE) ? getEtichetta(Etichette.Numero_Protocollo_Anno) : getEtichetta(Etichette.Numero_Registro_Anno)
            msg += " : " + comProt?.numeroProtocollo + "/" + comProt?.annoProtocollo
            if (comProt?.dataProtocollo != null) {
                msg += "  " + getEtichetta(Etichette.Del) + " " + DataUtils.fromDateToString(comProt.dataProtocollo)
            }
            return initStr + (msg ?: "") + "\n\n"
        } else {
            return ""
        }
    }

    private String getNominativoAtto(CivArchivioComunicazione arcCom){
        String nominativo
        try {
            CivAttoBaseDomain abd = civAttoService.getAttoFromComunicazione(arcCom.getTipoAtto(), arcCom.ufficio, arcCom.anno, arcCom.atto, arcCom.parte, arcCom.serie)
            nominativo = abd.getNominativoEstremiAtto(arcCom.tipoFormula, arcCom.tipoAttoComunicazione)
        } catch (EmptyResultDataAccessException e){
            nominativo = ("*** " + getEtichetta(Etichette.Atto_non_in_Archivio) + " ***")
            log.error(e.getMessage())
        }
        return nominativo
    }

    String getEstremiAtto(CivArchivioComunicazione c){
        String s = ""
        if (c?.id != null){
            try {
                CivAttoBaseDomain abd = civAttoService.getAttoFromComunicazione(c.getTipoAtto(), c.ufficio, c.anno, c.atto, c.parte, c.serie)
                s = abd.getNominativoEstremiAtto(c.tipoFormula, c.tipoAttoComunicazione)
                if (c.isAttoDiAltroComune()){
                    s = s + " " + getEtichetta(Etichette.Generata_da) + " " + getEtichettaEnum(abd.getTipoAttoEnum()) + " "
                }
            } catch (EmptyResultDataAccessException e){
                s = ("*** " + getEtichetta(Etichette.Atto_non_in_Archivio) + " ***")
                log.error(e.getMessage())
            }
        }
        return s
    }

    CivAttoBaseDomain getAttoComunicazione(CivArchivioComunicazione c){
        CivAttoBaseDomain abd = null
        if (c?.id != null){
            try {
                abd = civAttoService.getAttoFromComunicazione(c.getTipoAtto(), c.ufficio, c.anno, c.atto, c.parte, c.serie)
            } catch (EmptyResultDataAccessException e){
                log.error(e.getMessage())
                Messagebox.show(getEtichetta(Etichette.Atto_non_in_Archivio), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
        }
        return abd
    }

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// PROTOCOLLO ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    void caricaComunicazioneProtocollo(Long id){
        comunicazioneProtocollo = (id?civComunicazioneProtocolloService.get(id):null)
        BindUtils.postNotifyChange(null, null, this, "comunicazioneProtocollo")
    }

    @Command void onSalvaComunicazioneProtocollo(@BindingParam("arcCom") CivArchivioComunicazione arcCom) {
        if (comunicazioneProtocollo){
            CivComunicazioneProtocollo cp = civComunicazioneProtocolloService.save(comunicazioneProtocollo, arcCom)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaComunicazioneProtocollo(cp.id)
        }
    }

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// DESTINATARI ///////////////////////////
    ////////////////////////////////////////////////////////////////////////

    void caricaDestinatari(CivArchivioComunicazione arcCom){
        listaDestinatari = []
        if (arcCom?.id){
            listaDestinatari = civComunicazioneDestinatarioService.listAllByArchivioComunicazione(arcCom.id)
            for (CivComunicazioneDestinatario d:listaDestinatari){
                d.pec = statoCivileService.get_prot_indirizzo_pec(ConfigurazioneUtils.ARCHIVIO_RIFERIMENTO_STATO_CIVILE, d.ente?.id, d.codiceProvinciaDestinatario, d.codiceComuneDestinatario)
            }
        }
        BindUtils.postNotifyChange(null, null, this, "listaDestinatari")
    }

    @Command void onInserisciDestinatario(@BindingParam("arcCom") CivArchivioComunicazione arcCom) {
        Window w = (Window) Executions.createComponents("/restrict/statocivile/destinatariSelect.zul", self, [idArcCom: arcCom.id])
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            CivComunicazioneDestinatario dest = new CivComunicazioneDestinatario(archivioComunicazione: arcCom)
            if (event.data.dettaglio instanceof ArcComune){
                ArcComune comune = event.data.dettaglio
                dest.codiceComuneDestinatario = comune.codiceComune
                dest.codiceProvinciaDestinatario = comune.codiceProvincia
            }
            if (event.data.dettaglio instanceof CivEnte){
                CivEnte ente = event.data.dettaglio
                dest.ente = ente
            }
            salvaERicaricaDestinatari(dest, arcCom)
        })
        w.doModal()
    }

    void salvaERicaricaDestinatari(CivComunicazioneDestinatario destinatario, CivArchivioComunicazione arcCom){
        civComunicazioneDestinatarioService.save(destinatario)
        caricaDestinatari(arcCom)
    }

    @Command void onEliminaDestinatario(@BindingParam("destinatario") CivComunicazioneDestinatario destinatario) {
        if (destinatario && (!(destinatario.archivioComunicazione.isProtocollato())) ){
            Messagebox.show(destinatario.denominazione + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record), getEtichetta(Etichette.Destinatari), Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (Messagebox.ON_OK.equals(e.getName())){
                                eliminaERicaricaDestinatari(destinatario.id, destinatario.archivioComunicazione)
                            }
                        }
                    }
            )
        }
    }

    void eliminaERicaricaDestinatari(Long idDestinatario, CivArchivioComunicazione arcCom){
        CivComunicazioneDestinatario dest = civComunicazioneDestinatarioService.get(idDestinatario)
        civComunicazioneDestinatarioService.delete(dest)
        caricaDestinatari(arcCom)
    }

    @Command void onInviaPecDestinatario(@BindingParam("destinatario") CivComunicazioneDestinatario destinatario) {
        if (destinatario && destinatario.archivioComunicazione.isProtocollato() ){
            Messagebox.show(destinatario.denominazione + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Invio_Pec), getEtichetta(Etichette.Destinatari), Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (Messagebox.ON_OK.equals(e.getName())){
                                inviaPec(destinatario)
                            }
                        }
                    }
            )
        }
    }

    void inviaPec(CivComunicazioneDestinatario destinatario){
        String msg = civComunicazioneDestinatarioService.inviaPec(destinatario)
        if ( (msg?:"") != ""){
            Messagebox.show(msg, getEtichetta(Etichette.Comunicazioni), Messagebox.OK, Messagebox.ERROR)
        } else {
            Messagebox.show(getEtichetta(Etichette.Mail_Inviata), getEtichetta(Etichette.Comunicazioni), Messagebox.OK, Messagebox.INFORMATION)
        }
        caricaDestinatari(destinatario.archivioComunicazione)
    }

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// ALLEGATI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    void caricaAllegati(CivArchivioComunicazione arcCom){
        listaAllegati = []
        if (arcCom?.id){
            listaAllegati = civComunicazioneAllegatoService.listAllMetadatiByArchivioComunicazione(arcCom.id)
        }
        BindUtils.postNotifyChange(null, null, this, "listaAllegati")
    }

    @Command void onEliminaAllegato(@BindingParam("allegato") Map allegatoMap, @BindingParam("arcCom") CivArchivioComunicazione arcCom) {
        if (allegatoMap?.id){
            Messagebox.show((String)allegatoMap.nomeAllegato + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record), getEtichetta(Etichette.Allegati), Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (Messagebox.ON_OK.equals(e.getName())){
                                eliminaERicaricaAllegati(allegatoMap.id, arcCom)
                            }
                        }
                    }
            )
        }
    }

    void eliminaERicaricaAllegati(Long idAllegato, CivArchivioComunicazione arcCom){
        CivComunicazioneAllegato alle = civComunicazioneAllegatoService.get(idAllegato)
        civComunicazioneAllegatoService.deleteAllegato(alle)
        caricaAllegati(arcCom)
    }

    @Command void onDownloadAllegato(@BindingParam("allegato") Map allegatoMap) {
        if (allegatoMap){
            scaricaAllegato(allegatoMap.id, true)
        }
    }

    void scaricaAllegato(Long id, boolean sbusta = false, boolean segnalaSbustamento = true){
        CivComunicazioneAllegato alleCom = civComunicazioneAllegatoService.get(id)
        try{
            gsdFirmaService.scaricaAllegato(alleCom.archivioComunicazione, alleCom, sbusta, segnalaSbustamento)
        } catch (FileNonValidoRuntimeException fre){
            Messagebox.Button[] buttons = [Messagebox.Button.YES, Messagebox.Button.NO, Messagebox.Button.CANCEL] as Messagebox.Button[]
            String[] buttonsLabel = [getEtichetta(Etichette.SI), getEtichetta(Etichette.NO), getEtichetta(Etichette.Annulla)] as String[]
            Messagebox.show(alleCom.nome + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Sbustamento_File), getEtichetta(Etichette.Allegati), buttons, buttonsLabel , Messagebox.QUESTION, null,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (e.getName() == Messagebox.ON_YES){
                                scaricaAllegato(id, true, false)
                            }
                            if (e.getName() == Messagebox.ON_NO){
                                scaricaAllegato(id, false, false)
                            }
                        }
                    }
            )
        }
    }

    @Command void onUploadAllegato(@ContextParam(ContextType.TRIGGER_EVENT)UploadEvent event, @BindingParam("arcCom") CivArchivioComunicazione arcCom) {
        Media media = event.media
        byte[] _allegato = media.isBinary()?media.byteData:media.stringData.getBytes(StandardCharsets.UTF_8.name())
        String nomeFile = media.name
        // refs #62971
        Map<String, String> m = FileUtils.checkFile(_allegato, nomeFile, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (m){
            Messagebox.show(nomeFile + ":\n" + getEtichetta(m), msgTitle, Messagebox.OK, Messagebox.ERROR)
        } else {
            CivComunicazioneAllegato alleCom = new CivComunicazioneAllegato(archivioComunicazione:arcCom, nomeAllegato: nomeFile)
            InputStream is = new ByteArrayInputStream(_allegato)
            salvaAllegato(alleCom, Boolean.TRUE, is)
        }
    }

    @Command void onAllegaCopiaConforme(@BindingParam("arcCom") CivArchivioComunicazione arcCom) {
        CivAttoBaseDomain abd = getAttoComunicazione(arcCom)
        if (abd != null) {
            CivComunicazioneAllegato alleCom = new CivComunicazioneAllegato(archivioComunicazione: arcCom)
            civComunicazioneAllegatoService.validaDatiPre(alleCom)

            Map options = [dataSource: new JREmptyDataSource(), checkSinglePage: false, cia: true]

            JasperExporter exporter = stampaAttoService.generaReportAtto(abd, null, null, null, null, null, etichette, options)
            InputStream is = exporter.exportStream()

            alleCom.nomeAllegato = TestoUtils.getNomeReportAtto(abd, Boolean.TRUE)
            salvaAllegato(alleCom, Boolean.TRUE, is)
        }
    }

    @Command void onCambiaPrincipaleAllegato(@BindingParam("allegato") Map allegatoMap) {
        CivComunicazioneAllegato alleCom = civComunicazioneAllegatoService.get(allegatoMap.id)
        alleCom.principale = allegatoMap.principale
        salvaAllegato(alleCom, Boolean.FALSE, null)
    }

    static List<Map> etichetteComunicazioniDefault = [Etichette.Comunicazioni, Etichette.Destinatari, Etichette.Comunicazione, Etichette.Destinatario, Etichette.Generata_da,
                                                      Etichette.Allegati, Etichette.Numero_Protocollo_Anno, Etichette.Numero_Registro_Anno, Etichette.Del,
                                                      Etichette.Atto_non_in_Archivio, Etichette.RIEPILOGO_ELABORAZIONE, Etichette.Mail_Inviata,
                                                      EtichetteMessaggi.Salvataggio_Completato,
                                                      EtichetteMessaggi.Ask_Cancellazione_Record, EtichetteMessaggi.Ask_Aggiornamento_Testo_Comunicazione,
                                                      EtichetteMessaggi.Ask_Invio_Pec, EtichetteMessaggi.Ask_Conferma_Salvataggio,
                                                      EtichetteMessaggi.Ask_Conferma_Salvataggio_Documento, EtichetteMessaggi.Ask_Sbustamento_File,
                                                      EtichetteMessaggi.Errore_protocollazione_comunicazioni_provvisorie,
                                                      EtichetteMessaggi.Errore_esecuzione_comunicazioni_protocollate, EtichetteMessaggi.Errore_esecuzione_comunicazioni_inviate_albo,
                                                      EtichetteMessaggi.Errore_generazione_testo, EtichetteMessaggi.Errore_modello_testo_non_trovato,
                                                      EtichetteMessaggi.Errore_testo_principale_comunicazione, EtichetteMessaggi.Errore_no_tipo_documento_x_fascicolazione,
                                                      EtichetteMessaggi.Errore_Operazione_non_consentita, EtichetteMessaggi.Errore_salvataggio_file_documentale,
                                                      EtichetteMessaggi.Warn_Nessuna_comunicazione_selezionata, EtichetteMessaggi.Warn_comunicazione_fascicolata,
                                                      EtichetteMessaggi.Warn_Nessuna_comunicazione_da_protocollare, EtichetteMessaggi.Warn_Nessuna_comunicazione_da_inviare_albo]
}
