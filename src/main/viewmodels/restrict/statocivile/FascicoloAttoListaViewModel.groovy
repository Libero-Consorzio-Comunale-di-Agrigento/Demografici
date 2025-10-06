package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscComunicazioneAllegatoService
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarFascicoloAttributes
import it.finmatica.de4gsdzk.zkutils.ScanEvent
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.util.media.Media
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Filedownload
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import java.nio.charset.StandardCharsets

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FascicoloAttoListaViewModel extends RiferimentiAttoListaParentViewModel{

    List<DocumentoFascicolo> lista
    DocumentoFascicolo dettaglio

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    List<CivTipoDocumentoFascicolo> listaTipoDocumento

    @WireVariable
    private CivFascicoloAttoService civFascicoloAttoService

    @WireVariable
    private CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

    @WireVariable
    private CivTipoDocumentoFascicoloService civTipoDocumentoFascicoloService

    @WireVariable
    private CivComunicazioneProtocolloService civComunicazioneProtocolloService

    @WireVariable
    private AnscComunicazioneAllegatoService anscComunicazioneAllegatoService

    @WireVariable
    private StatoCivileService statoCivileService

    @Delegate
    ControlBarFascicoloAttributes cbFasc = new ControlBarFascicoloAttributes()

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {
        self = w

        backFromListFascicoloEnabled = true
        pagingFascicoloEnabled = true
        uploadFascicoloEnabled = true
        scansionaEnabled = true
        importaDaProtocolloEnabled = true

        List<Map> eList = [Etichette.Fascicolo, Etichette.Documento, Etichette.Chiusura, Etichette.inserisci_allegato_tooltip,
                           Etichette.Data_decrescente, Etichette.Data_crescente, Etichette.Tipo_Documento_crescente, Etichette.Tipo_Documento_decrescente,
                           Etichette.Numero_Protocollo_Anno, Etichette.Del, Etichette.Atto_Divorzio, Etichette.Atto_Scioglimento,
                           Etichette.Allegati, Etichette.Allegato, Etichette.SEZIONE_FASCICOLO_ATTO]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Ask_Sbustamento_File, EtichetteMessaggi.Ask_Cancellazione_Fascicolo, EtichetteMessaggi.Ask_tipo_file_ANSC])
        eList.addAll(CivFascicoloAtto.etichetteDomain)
        eList.addAll(CivFascicoloAttoAllegato.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarFascicoloAttributes.etichetteCbFascDesc)

        // Aggiungo etichette delle Comunicazioni
        eList.addAll(CivArchivioComunicazione.etichetteDomain)

        doInit(eList, pkAtto, tipoAttoEnum) //carica anche atto e dati provenienza

        msgTitle = getEtichetta(Etichette.Fascicolo)
        formLabel = getEtichetta(Etichette.SEZIONE_FASCICOLO_ATTO)

        totalSizeLabel = ""

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Tipo_Documento_crescente),    SortUtils.tipoDocumentoFascicoloAsc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Tipo_Documento_decrescente),  SortUtils.tipoDocumentoFascicoloDesc))

        //Default: data crescente
        selectedOrder = listaOrder[0]

        resize()

        listaTipoDocumento = civTipoDocumentoFascicoloService.listAllByTipoAttoOrderByDescrizione(tipoAttoEnum)?.toList()

        caricaLista()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest( usePaging?activePage:0, usePaging?pageSize:Integer.MAX_VALUE, new Sort(selectedOrder.campi))
        Page<CivFascicoloAtto> p = civFascicoloAttoService.listAllByAtto(atto, pr)
        List l = []
        for (CivFascicoloAtto fa : p) {
            List<CivFascicoloAttoAllegato> listaAlleFas = civFascicoloAttoAllegatoService.listAllByIdFascicoloAttoOrderByDataModifica(fa.id)
            Boolean modifyTipoEnabled = Boolean.TRUE
            for (CivFascicoloAttoAllegato fal:listaAlleFas){
                if (anscComunicazioneAllegatoService.existsComunicazioneByIdAllegatoAndInviatoANSC(fal.id)){
                    modifyTipoEnabled = Boolean.FALSE
                    break
                }
            }
            l.add(new DocumentoFascicolo(fa, modifyTipoEnabled, listaAlleFas))
            try {
                // serve per eventuale passaggio atto da provvisorio a definitivo
                civFascicoloAttoService.allineaGdm(fa)
            } catch (DocumentaleRuntimeException ex) {
                log.warn("Allineamento con gdm non riuscito: " + ex.message)
            }
        }
        return new Paginazione(l, p?.getTotalElements()?:0)
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    boolean getLoadOnCloseData(){
        return true
    }

    private void caricaFascicolo(Long id){
        if (id){
            for (DocumentoFascicolo t : lista){
                if (t.getFascicolo().id.compareTo(id) == 0){
                    dettaglio = t
                    refreshDettaglio()
                    break
                }
            }
        } else {
            resetDettaglio()
        }
    }

    @Command void onSelectTipoDocumento() {
        refreshDettaglio()
    }

    @Command void onSalvaFascicolo(@BindingParam("fascicolo") CivFascicoloAtto fa) {
        if (getDettaglio()){
            // Siamo nel fascicolo: l'eventuale comunicazione fascicolata è già stata salvata su gdm
            Boolean refersComunicazione = civFascicoloAttoService.refersComunicazione(fa.id)
            CivFascicoloAtto faSaved = civFascicoloAttoService.save(fa, (!(refersComunicazione)))
            onPagina()
            caricaFascicolo(faSaved?.id)
        }
    }

    @Command void onEliminaFascicolo(@BindingParam("fascicolo") CivFascicoloAtto fa) {
        if (fa && userModifyEnabled) {
            Messagebox.show(fa.tipoDocumentoFascicolo.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (Messagebox.ON_OK.equals(e.getName())){
                                eliminaFascicolo(fa)
                            }
                        }
                    }
            )
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void eliminaFascicolo(CivFascicoloAtto fa){
        civFascicoloAttoAllegatoService.deleteFascicoloEAllegati(fa)
        onRicarica()
    }

    static final String uriTipoAllegato = "/restrict/statocivile/tipoDocumentoFascicoloSelect.zul"

    void addAllegatoToFascicolo(CivFascicoloAtto fa, String nomeFile, InputStream inputStream, Boolean scarica=Boolean.FALSE, String contentType=null){
        CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoService.create(fa, nomeFile)

        CivFascicoloAttoAllegato falSaved = civFascicoloAttoAllegatoService.save(fal, Boolean.TRUE, inputStream)

        if (scarica){
            Filedownload.save(inputStream, contentType, nomeFile)
        }

        onRicarica()
        caricaFascicolo((civFascicoloAttoAllegatoService.get(falSaved?.id)).fascicoloAtto?.id)
    }

    @Command void onUploadFascicolo(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event) {
        Media media = event.media
        byte[] _allegato = media.isBinary()?media.byteData:media.stringData.getBytes(StandardCharsets.UTF_8.name())
        String nomeFile = media.name
        Map<String, String> m = FileUtils.checkFile(_allegato, nomeFile, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (m){
            Messagebox.show(nomeFile + ":\n" + getEtichetta(m), msgTitle, Messagebox.OK, Messagebox.ERROR)
        } else {
            Window w = (Window) Executions.createComponents(uriTipoAllegato, self, [tipoAttoEnum: tipoAttoEnum])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { e ->
                if ( e.data instanceof CivTipoDocumentoFascicolo ){
                    CivTipoDocumentoFascicolo tdf = (CivTipoDocumentoFascicolo)e.data
                    if (tdf.tipoAllegatoANSC != null) {
                        String retVal = statoCivileService.verificaAllegatoAnsc(null, null, nomeFile)
                        if ( (retVal?:"") != ""){
                            Messagebox.show(retVal + ".\n" + getEtichetta(EtichetteMessaggi.Ask_tipo_file_ANSC), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                                    new org.zkoss.zk.ui.event.EventListener(){
                                        void onEvent(Event evt){
                                            if (Messagebox.ON_OK == evt.getName()) {
                                                createAndAddToFascicolo(tdf, nomeFile, new ByteArrayInputStream(_allegato))
                                            }
                                        }
                                    }
                            )
                        } else {
                            createAndAddToFascicolo(tdf, nomeFile, new ByteArrayInputStream(_allegato))
                        }
                    } else {
                        createAndAddToFascicolo(tdf, nomeFile, new ByteArrayInputStream(_allegato))
                    }
                }
            })
            w.doModal()
        }
    }

    protected void createAndAddToFascicolo(CivTipoDocumentoFascicolo tdf, String nomeFile,  InputStream b){
        CivFascicoloAtto fa = civFascicoloAttoService.createWhereNotExists(atto, tdf)
        addAllegatoToFascicolo(fa, nomeFile, b)
    }

    @Command void onScanFascicolo(@ContextParam(ContextType.TRIGGER_EVENT) ScanEvent event) {
        if (event){
            String nomeFile = event.filename
            InputStream inputStream = event.inputStream
            Window w = (Window) Executions.createComponents(uriTipoAllegato, self, [tipoAttoEnum: tipoAttoEnum])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { e ->
                if (e.data instanceof CivTipoDocumentoFascicolo){
                    CivTipoDocumentoFascicolo tdf = (CivTipoDocumentoFascicolo)e.data
                    CivFascicoloAtto fa = civFascicoloAttoService.createWhereNotExists(atto, tdf)
                    addAllegatoToFascicolo(fa, nomeFile, inputStream, Boolean.TRUE, event.contentType)
                }
            })
            w.doModal()
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    String getEstremiProtocollo(DocumentoFascicolo d){
        if (d?.fascicolo?.archivioComunicazione){
            CivArchivioComunicazione arcCom = d?.fascicolo?.archivioComunicazione
            if (arcCom.isProtocollato()){
                CivComunicazioneProtocollo cp = civComunicazioneProtocolloService.get(d.fascicolo.archivioComunicazione.id)
                String estremiProtocolloLabel =  ((cp.numeroProtocollo != null)? getEtichetta(Etichette.Numero_Protocollo_Anno):"") + " " + (cp.numeroProtocollo?:"") + "/" + (cp.annoProtocollo?:"")
                String dataProtocolloLabel = (cp.dataProtocollo? getEtichetta(Etichette.Del):"") + " " + (DataUtils.fromDateToString(cp.dataProtocollo)?:"")
                return estremiProtocolloLabel + " " + dataProtocolloLabel
            }
        }
        return ""
    }

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////// ALLEGATI //////////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @Command void onUploadAllegatoFascicolo(@ContextParam(ContextType.TRIGGER_EVENT)UploadEvent event, @BindingParam("fascicolo") CivFascicoloAtto fa) {
        Media media = event.media
        byte[] _allegato = media.isBinary()?media.byteData:media.stringData.getBytes(StandardCharsets.UTF_8.name())
        String nomeFile = media.name
        Map<String, String> m = FileUtils.checkFile(_allegato, nomeFile, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (m){
            Messagebox.show(nomeFile + ":\n" + getEtichetta(m), msgTitle, Messagebox.OK, Messagebox.ERROR)
        } else {
            // In questo caso salvo solo su fascicolo e documentale (NON salvo su civcom_alle eventuali allegati di comunicazioni)
            CivTipoDocumentoFascicolo tdf = civTipoDocumentoFascicoloService.get(fa.tipoDocumentoFascicolo.id)
            if (tdf.tipoAllegatoANSC != null){
                String retVal = statoCivileService.verificaAllegatoAnsc(null, null, nomeFile)
                if ( (retVal?:"") != ""){
                    Messagebox.show(retVal + ".\n" + getEtichetta(EtichetteMessaggi.Ask_tipo_file_ANSC), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                            new org.zkoss.zk.ui.event.EventListener(){
                                void onEvent(Event evt){
                                    if (Messagebox.ON_OK == evt.getName()) {
                                        addAllegatoToFascicolo(fa, nomeFile, new ByteArrayInputStream(_allegato))
                                    }
                                }
                            }
                    )
                } else {
                    addAllegatoToFascicolo(fa, nomeFile, new ByteArrayInputStream(_allegato))
                }
            } else {
                addAllegatoToFascicolo(fa, nomeFile, new ByteArrayInputStream(_allegato))
            }
        }
    }

    @Command void onDownloadAllegatoFascicolo(@BindingParam("allegatoFascicolo") CivFascicoloAttoAllegato fal) {
        scaricaAllegatoFascicolo(fal, true)
    }

    void scaricaAllegatoFascicolo(CivFascicoloAttoAllegato fal, boolean sbusta = false, boolean segnalaSbustamento = true){
        try{
            civFascicoloAttoAllegatoService.scaricaAllegato(fal, sbusta, segnalaSbustamento)
        } catch (FileNonValidoRuntimeException fre){
            Messagebox.Button[] buttons = [Messagebox.Button.YES, Messagebox.Button.NO, Messagebox.Button.CANCEL] as Messagebox.Button[]
            String[] buttonsLabel = [getEtichetta(Etichette.SI), getEtichetta(Etichette.NO), getEtichetta(Etichette.Annulla)] as String[]
            Messagebox.show(fal.nome + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Sbustamento_File), getEtichetta(Etichette.Allegati), buttons, buttonsLabel , Messagebox.QUESTION, null,
                new org.zkoss.zk.ui.event.EventListener(){
                    void onEvent(Event e){
                        if (e.getName() == Messagebox.ON_YES){
                            scaricaAllegatoFascicolo(fal, true, false)
                        }
                        if (e.getName() == Messagebox.ON_NO){
                            scaricaAllegatoFascicolo(fal, false, false)
                        }
                    }
                }
            )
        }
    }

    @Command void onEliminaAllegatoFascicolo(@BindingParam("allegatoFascicolo") CivFascicoloAttoAllegato fal) {
        if (fal && userModifyEnabled) {
            Messagebox.show(fal.nome + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Fascicolo), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener(){
                    void onEvent(Event e){
                        if (Messagebox.ON_OK.equals(e.getName())){
                            CivFascicoloAtto fa = fal.fascicoloAtto
                            civFascicoloAttoAllegatoService.deleteAllegato(fal)
                            onPagina()
                            caricaFascicolo(fa.id)
                        }
                    }
                }
            )
        }
    }

    @Command void onEditaNote(@BindingParam("allegatoFascicolo") CivFascicoloAttoAllegato fal) {
        CivFascicoloAtto fa = fal.fascicoloAtto
        Window w = (Window) Executions.createComponents("/restrict/afc/popupNote.zul", self, [fascicoloAllegato: fal])
        w.addEventListener(CustomEvents.ON_CLOSE_RELOAD, { e ->
            onPagina()
            caricaFascicolo(fa.id)
        })
        w.doModal()
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

}
