package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiFascicoloRuntimeException
import it.finmatica.de4gsdzk.export.JasperExporter
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarComunicazioniAttributes
import it.finmatica.gestionetesti.GestioneTestiService
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import net.sf.jasperreports.engine.JREmptyDataSource
import org.springframework.dao.EmptyResultDataAccessException
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
import restrict.TraitComunicazioni

import java.nio.charset.StandardCharsets

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class ComunicazioniAttoListaParentViewModel extends RiferimentiAttoListaParentViewModel implements TraitComunicazioni {

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    List<CivArchivioComunicazione> lista
    List<CivArchivioComunicazione> listaComunicazioniSelezionate
    CivArchivioComunicazione _dettaglio
    CivComunicazioneProtocollo comunicazioneProtocollo
    List<CivComunicazioneDestinatario> listaDestinatari
    List<CivComunicazioneAllegato> listaAllegati

    Boolean massiveCheck
    Boolean showDetailsComunicazione = Boolean.FALSE
    Boolean showDetailsAtto = Boolean.FALSE
    Boolean showMassiveCheck = Boolean.TRUE
    Boolean showDeleteOption = Boolean.TRUE
    Boolean showRecapMessage = Boolean.TRUE

    String managePrincipale
    Boolean firmaRemotaAutomatica

    @Delegate
    ControlBarComunicazioniAttributes cbComList = new ControlBarComunicazioniAttributes()

    @WireVariable
    private CivArchivioComunicazioneService civArchivioComunicazioneService

    IArchivioComunicazioneService getArchivioComunicazioneService() {
        return civArchivioComunicazioneService
    }

    @WireVariable
    private CivComunicazioneProtocolloService civComunicazioneProtocolloService

    IComunicazioneProtocolloService getComunicazioneProtocolloService() {
        return civComunicazioneProtocolloService
    }

    @WireVariable
    private CivComunicazioneDestinatarioService civComunicazioneDestinatarioService

    IComunicazioneDestinatarioService getComunicazioneDestinatarioService() {
        return civComunicazioneDestinatarioService
    }

    @WireVariable
    private CivComunicazioneAllegatoService civComunicazioneAllegatoService

    IComunicazioneAllegatoService getComunicazioneAllegatoService() {
        return civComunicazioneAllegatoService
    }

    @WireVariable
    private CivComunicazioneAttoService civComunicazioneAttoService

    @WireVariable
    private CivComunicazioneFormulaService civComunicazioneFormulaService

    @WireVariable
    private GsdService gsdService

    GsdService getGsdService() {
        return gsdService
    }

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private GestioneTestiService gestioneTestiService

    @WireVariable
    private GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    @WireVariable
    private GsdFirmaService gsdFirmaService

    GsdFirmaService getGsdFirmaService() {
        return gsdFirmaService
    }

    @WireVariable
    private StampaAttoService stampaAttoService

    @WireVariable
    private ArcParametroService arcParametroService

    void leggiParametri(){
        managePrincipale = arcParametroService.isModificaAllegatoPrincipaleComunicazioneAttiva()
        firmaRemotaAutomatica = arcParametroService.isFirmaRemotaAutomaticaAttiva()
    }

    CivArchivioComunicazione getDettaglio(){
        return _dettaglio
    }

    void setArchivio(IArchivioComunicazione arcCom) {
        _dettaglio = arcCom as CivArchivioComunicazione
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
        selezionaTutte()
    }

    @Command void onSelezionaComunicazione(@BindingParam("selected") Boolean selected, @BindingParam("comunicazione") CivArchivioComunicazione arcCom) {
        seleziona(selected, arcCom, Boolean.TRUE)
    }

    @Command void onEliminaComunicazione(@BindingParam("comunicazione") CivArchivioComunicazione arcCom) {
        if (arcCom?.comunicazione && showDeleteOption){
            Messagebox.show(arcCom.comunicazione.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (Messagebox.ON_OK.equals(e.getName())){
                                eliminaERicaricaComunicazione(arcCom)
                                onRicarica()
                            }
                        }
                    }
            )
        }
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


    @Command void onFascicolaComunicazione(@BindingParam("arcCom") CivArchivioComunicazione arcCom) {
        if (arcCom) {
            fascicolaComunicazioneEAllegati(arcCom, Boolean.TRUE)
        }
    }

    void fascicolaComunicazioneEAllegati(IArchivioComunicazione _arcCom, Boolean refreshComunicazione=Boolean.FALSE){
        CivArchivioComunicazione arcCom = _arcCom as CivArchivioComunicazione
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
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                onPagina()
                caricaComunicazione(arcCom.id)
            } else {
                Messagebox.show(arcCom.comunicazione.descrizione + "\n" + getEtichetta(Etichette.getEtichetta("Warn_comunicazione_fascicolata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onGeneraTesti() {
        generaTesti()
    }

    void showCustomMessagebox(IArchivioComunicazione c) {
        Window w = (Window) Executions.createComponents("/restrict/statocivile/customMessagebox.zul", self, [titolo      : getEtichetta(Etichette.getEtichetta("Comunicazioni")),
                                                                                                             msg         : (c.comunicazione.descrizione + ":\n" +  getEtichetta(Etichette.getEtichetta("Ask_Aggiornamento_Testo_Comunicazione")) ),
                                                                                                             listaOpzioni:[Etichette.getEtichetta("SI"), Etichette.getEtichetta("NO")], params: [arcCom: c]])
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            if (event.data.opzione.codice == Etichette.getEtichetta("SI").codice){
                generaTestoComunicazione(event.data.params.arcCom, Boolean.TRUE)
            }
        })
        w.doModal()
    }

    void generaTestoComunicazione(IArchivioComunicazione _c, Boolean scaricaDopoGenerazione){
        CivArchivioComunicazione c = _c as CivArchivioComunicazione
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
                Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Errore_modello_testo_non_trovato")), msgTitle, Messagebox.OK, Messagebox.ERROR)
                return
            }
            log.info("Avvio recupero xml data per comunicazione ${c.id}")
            String queryModello = gsdService.getDataSourceXmlComunicazione(c)
            log.info("Recuperato xml data per comunicazione ${c.id}")
            String formato = (g.formatoTesto?.name()?:g.tipo).toLowerCase()
            alleCom.nomeAllegato = "${c.nomeFileComunicazione}_${c.idAtto}.${formato}"
            ByteArrayInputStream bais = new ByteArrayInputStream(g.fileTemplate)
            InputStream is = gestioneTestiService.stampaUnione(bais, queryModello, parametriQuery, formato, true, StandardCharsets.UTF_8)
            salvaAllegato(alleCom, Boolean.TRUE, is, Boolean.TRUE, Boolean.TRUE, scaricaDopoGenerazione)
        } catch (Exception ex){
            log.error("Errore stampa comunicazione", ex)
            String msg = getEtichetta(Etichette.getEtichetta("Errore_generazione_testo"))
            if (ex instanceof De4gsdzkRuntimeException){
                msg = ex.message
            }
            Messagebox.show(c.comunicazione.descrizione + ":\n" +  msg, msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        refreshLista()
    }

    void scaricaAllegatiComeZip(List<IArchivioComunicazione> comunicazioniGenerate) {
        List<IComunicazioneAllegato> allegati = []
        for (IArchivioComunicazione c : comunicazioniGenerate) {
            IComunicazioneAllegato alle = civComunicazioneAllegatoService.getPrincipale(c.id)
            if (alle) {
                allegati.add(alle)
            }
        }
        if (!allegati.isEmpty()) {
            gsdFirmaService.scaricaAllegatiZip("comunicazioni_${atto?.idAtto ?: DataUtils.fromDateToString(DataUtils.getDataCorrente(), "ddMMyyyy")}", allegati)
        }
    }

    void salvaAllegato(CivComunicazioneAllegato alleCom, Boolean salvaSuDocumentale, InputStream is,
                       Boolean ignoreStampaEseguita=Boolean.FALSE, Boolean aggiornaStampaEseguita=Boolean.FALSE, Boolean scaricaAllegato=Boolean.FALSE){
        try {
            civComunicazioneAllegatoService.save(alleCom, salvaSuDocumentale, is, Boolean.FALSE, ignoreStampaEseguita, aggiornaStampaEseguita)
            if (scaricaAllegato){
                onDownloadAllegato(alleCom)
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
            Messagebox.show(alleCom.nome + ":\n" + (getEtichetta(Etichette.getEtichetta("Errore_salvataggio_file_documentale"))?:dre.getMessage()) + "\n" + getEtichetta(Etichette.getEtichetta("Ask_Conferma_Salvataggio_Documento")),
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
        protocolla()
    }

    @Command void onInviaAlbo() {
        if (tipoAttoEnum == ETipoAtto.PUB){
            inviaAlbo()
        }
    }

    String getDettaglioComunicazioneRecapMsg(IArchivioComunicazione _arcCom){
        CivArchivioComunicazione arcCom = _arcCom as CivArchivioComunicazione
        String msg = arcCom.comunicazione.descrizione + ":\n"
        if (showRecapMessage){
            msg += "  " + getNominativoAtto(arcCom) + "\n"
        }
        return msg
    }

    String addToRecapMsg(String initStr, ETipoElaborazioneComunicazione tipoElaborazione, IArchivioComunicazione _arcCom) {
        CivArchivioComunicazione arcCom = _arcCom as CivArchivioComunicazione
        if (showRecapMessage) {
            CivComunicazioneProtocollo comProt = (arcCom.id ? civComunicazioneProtocolloService.get(arcCom.id) : null)
            String msg = arcCom.comunicazione.descrizione + ":\n"
            msg += "  " + getNominativoAtto(arcCom) + "\n"
            msg += (tipoElaborazione == ETipoElaborazioneComunicazione.PROTOCOLLAZIONE) ? getEtichetta(Etichette.getEtichetta("Numero_Protocollo_Anno")) : getEtichetta(Etichette.getEtichetta("Numero_Registro_Anno"))
            msg += " : " + comProt?.numeroProtocollo + "/" + comProt?.annoProtocollo
            if (comProt?.dataProtocollo != null) {
                msg += "  " + getEtichetta(Etichette.getEtichetta("Del")) + " " + DataUtils.fromDateToString(comProt.dataProtocollo)
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
            nominativo = ("*** " + getEtichetta(Etichette.getEtichetta("Atto_non_in_Archivio")) + " ***")
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
                    s = s + " " + getEtichetta(Etichette.getEtichetta("Generata_da")) + " " + getEtichettaEnum(abd.getTipoAttoEnum()) + " "
                }
            } catch (EmptyResultDataAccessException e){
                s = ("*** " + getEtichetta(Etichette.getEtichetta("Atto_non_in_Archivio")) + " ***")
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
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Atto_non_in_Archivio")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
        }
        return abd
    }

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// PROTOCOLLO ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    void setComunicazioneProtocollo(IComunicazioneProtocollo protocollo) {
        comunicazioneProtocollo = protocollo as CivComunicazioneProtocollo
    }

    @Command void onSalvaComunicazioneProtocollo(@BindingParam("arcCom") CivArchivioComunicazione arcCom) {
        salvaComunicazioneProtocollo(arcCom)
    }

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// DESTINATARI ///////////////////////////
    ////////////////////////////////////////////////////////////////////////


    void setListaDestinatari(List<IComunicazioneDestinatario> destinatari) {
        listaDestinatari = destinatari as List<CivComunicazioneDestinatario>
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

    @Command void onEliminaDestinatario(@BindingParam("destinatario") CivComunicazioneDestinatario destinatario) {
        if (destinatario && (!(destinatario.archivioComunicazione.isProtocollato())) ){
            Messagebox.show(destinatario.denominazione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), getEtichetta(Etichette.getEtichetta("Destinatari")), Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
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


    @Command void onInviaPecDestinatario(@BindingParam("destinatario") CivComunicazioneDestinatario destinatario) {
        if (destinatario && destinatario.archivioComunicazione.isProtocollato() ){
            Messagebox.show(destinatario.denominazione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Invio_Pec")), getEtichetta(Etichette.getEtichetta("Destinatari")), Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
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

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// ALLEGATI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////


    void setListaAllegati(List<IComunicazioneAllegato> allegati) {
        listaAllegati = allegati as List<CivComunicazioneAllegato>
    }

    @Command void onEliminaAllegato(@BindingParam("allegato") CivComunicazioneAllegato allegato, @BindingParam("arcCom") CivArchivioComunicazione arcCom) {
        if (allegato?.id){
            Messagebox.show((String)allegato.nomeAllegato + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), getEtichetta(Etichette.getEtichetta("Allegati")), Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (Messagebox.ON_OK.equals(e.getName())){
                                eliminaERicaricaAllegati(allegato.id, arcCom)
                            }
                        }
                    }
            )
        }
    }


    @Command void onDownloadAllegato(@BindingParam("allegato") CivComunicazioneAllegato allegato) {
        if (allegato){
            scaricaAllegato(allegato.id, true)
        }
    }

    void fileNonValido(IComunicazioneAllegato _alleCom, Long id) {
        CivComunicazioneAllegato alleCom = _alleCom as CivComunicazioneAllegato
        Messagebox.Button[] buttons = [Messagebox.Button.YES, Messagebox.Button.NO, Messagebox.Button.CANCEL] as Messagebox.Button[]
        String[] buttonsLabel = [getEtichetta(Etichette.getEtichetta("SI")), getEtichetta(Etichette.getEtichetta("NO")), getEtichetta(Etichette.getEtichetta("Annulla"))] as String[]
        Messagebox.show(alleCom.nome + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Sbustamento_File")), getEtichetta(Etichette.getEtichetta("Allegati")), buttons, buttonsLabel , Messagebox.QUESTION, null,
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

    @Command void onUploadAllegato(@ContextParam(ContextType.TRIGGER_EVENT)UploadEvent event, @BindingParam("arcCom") CivArchivioComunicazione arcCom) {
        Media media = event.media
        byte[] _allegato = media.isBinary()?media.byteData:media.stringData.getBytes(StandardCharsets.UTF_8.name())
        String nomeFile = media.name
        // refs #62971
        Map<String, String> m = FileUtils.checkFile(_allegato, FileUtils.defaultAcceptableMimeTypesXComEFas)
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

    @Command void onCambiaPrincipaleAllegato(@BindingParam("allegato") CivComunicazioneAllegato allegato) {
        CivComunicazioneAllegato alleCom = civComunicazioneAllegatoService.get(allegato.id) as CivComunicazioneAllegato
        alleCom.principale = allegato.principale
        salvaAllegato(alleCom, Boolean.FALSE, null)
    }

    static List<Map> etichetteComunicazioniDefault = [Etichette.getEtichetta("Comunicazioni"), Etichette.getEtichetta("Destinatari"), Etichette.getEtichetta("Comunicazione"), Etichette.getEtichetta("Destinatario"), Etichette.getEtichetta("Generata_da"),
                                                      Etichette.getEtichetta("Allegati"), Etichette.getEtichetta("Numero_Protocollo_Anno"), Etichette.getEtichetta("Numero_Registro_Anno"), Etichette.getEtichetta("Del"),
                                                      Etichette.getEtichetta("Atto_non_in_Archivio"), Etichette.getEtichetta("RIEPILOGO_ELABORAZIONE"), Etichette.getEtichetta("Mail_Inviata"),
                                                      Etichette.getEtichetta("Salvataggio_Completato"),
                                                      Etichette.getEtichetta("Ask_Cancellazione_Record"), Etichette.getEtichetta("Ask_Aggiornamento_Testo_Comunicazione"),
                                                      Etichette.getEtichetta("Ask_Invio_Pec"), Etichette.getEtichetta("Ask_Conferma_Salvataggio"),
                                                      Etichette.getEtichetta("Ask_Conferma_Salvataggio_Documento"), Etichette.getEtichetta("Ask_Sbustamento_File"),
                                                      Etichette.getEtichetta("Errore_protocollazione_comunicazioni_provvisorie"),
                                                      Etichette.getEtichetta("Errore_esecuzione_comunicazioni_protocollate"), Etichette.getEtichetta("Errore_esecuzione_comunicazioni_inviate_albo"),
                                                      Etichette.getEtichetta("Errore_generazione_testo"), Etichette.getEtichetta("Errore_modello_testo_non_trovato"),
                                                      Etichette.getEtichetta("Errore_testo_principale_comunicazione"), Etichette.getEtichetta("Errore_no_tipo_documento_x_fascicolazione"),
                                                      Etichette.getEtichetta("Errore_Operazione_non_consentita"), Etichette.getEtichetta("Errore_salvataggio_file_documentale"),
                                                      Etichette.getEtichetta("Warn_Nessuna_comunicazione_selezionata"), Etichette.getEtichetta("Warn_comunicazione_fascicolata"),
                                                      Etichette.getEtichetta("Warn_Nessuna_comunicazione_da_protocollare"), Etichette.getEtichetta("Warn_Nessuna_comunicazione_da_inviare_albo")]
}
