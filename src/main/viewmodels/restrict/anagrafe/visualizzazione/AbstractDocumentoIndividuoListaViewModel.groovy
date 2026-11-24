package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAttributes
import it.finmatica.de4gsdzk.zkutils.ScanEvent
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.util.media.Media
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitControlBarCapable

import java.nio.charset.StandardCharsets

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractDocumentoIndividuoListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi, TraitControlBarCapable, TraitIndividuoCorrente {

    List<AnaDocumento> lista
    AnaDocumento dettaglio

    List<AnaDocumentoAllegato> allegatoLista

    FunzioniPresentation<EFunzioneDocumento> funzioniDettaglio = new FunzioniPresentation<>(EFunzioneDocumento.class)

    List<OrderBy> listaOrder = []

    OrderBy selectedOrder

    @WireVariable
    private AnaTipoDocumentoService anaTipoDocumentoService

    @WireVariable
    protected AnaDocumentoService anaDocumentoService

    @WireVariable
    protected AnaDocumentoAllegatoService anaDocumentoAllegatoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService


    void doInit(Window w, List<Map<String, String>> eList = []) {
        self = w

        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette entità
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnaDocumento.etichetteDomain)
        eList.addAll(AnaDocumentoAllegato.etichetteDomain)
        eList.addAll(ENaturaDocumento.values()*.getEtichettaDesc())
        eList.addAll(EFunzioneDocumento.values()*.getEtichettaDesc())

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarAttributes.etichetteCbDesc)

        // Aggiungo etichette order
        eList.addAll([Etichette.getEtichetta("Data_emissione_decrescente"), Etichette.getEtichetta("Data_emissione_crescente")])

        eList.addAll([Etichette.getEtichetta("Warn_Nessun_elemento_selezionato"), Etichette.getEtichetta("Errore_file_formato")])

        // Aggiungo etichette funzioni dettaglio
        eList.addAll(EFunzioneDocumento.values()*.getEtichettaDesc())

        // Aggiungo etichette funzioni di ogni riga
        eList.addAll([Etichette.getEtichetta("inserisci_allegato_tooltip"), Etichette.getEtichetta("scarica_allegato_tooltip"), Etichette.getEtichetta("info_tooltip"), Etichette.getEtichetta("scarica_allegati_tooltip"), Etichette.getEtichetta("elimina_allegato_tooltip")])

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([Etichette.getEtichetta("Errore_nome_allegato_esistente"), Etichette.getEtichetta("Ask_Cancellazione_Allegato")])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        totalSizeLabel = ""

        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Data_emissione_decrescente")), SortUtils.dataEmissioneDocumentoDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Data_emissione_crescente")), SortUtils.dataEmissioneDocumentoAsc)])

        //Default: data emissione discendente
        selectedOrder = listaOrder[0]

        resize()

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    void resetLista() {
        lista = []
        refreshLista()
    }

    @Command
    void onBack() {
        Events.postEvent(CustomEvents.ON_BACK_FROM_LIST, self, [:])
        onChiudi()
    }

    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Command
    void onSelectDettaglio() {
        caricaDettaglio()
    }

    protected void caricaDettaglio() {
        allegatoLista = anaDocumentoAllegatoService.listAllByDocumento(dettaglio)
        dettaglio.allegati = allegatoLista //refresh della lista allegata al documento
        funzioniDettaglio.setFunzioni(anaDocumentoService.getFunzioniDocumento(dettaglio))
        refreshUi()
    }

    @Command
    void onDownloadDocumento() {
        anaDocumentoService.downloadAllegati(dettaglio)
    }

    @Command
    void onUploadDocumentoAllegato(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event) {
        Media media = event.media
        byte[] fileContent = media.isBinary() ? media.byteData : media.stringData.getBytes(StandardCharsets.UTF_8.name())
        Map<String, String> etichettaErrore = FileUtils.checkFile(fileContent, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (etichettaErrore) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(etichettaErrore))
            return
        }

        salvaAllegato(media.name, fileContent)

    }

    private void salvaAllegato(String nomeAllegato, byte[] contenutoAllegato) {
        AnaDocumentoAllegato allegato = anaDocumentoAllegatoService.create(dettaglio, nomeAllegato)
        anaDocumentoAllegatoService.save(allegato)

        try {
            EModelloGdm modello = anaTipoDocumentoService.getModelloGdm(dettaglio.tipoDocumento)

            anaDocumentoAllegatoService.saveAllegatoDocumentale(modello, allegato, contenutoAllegato)
            caricaDettaglio()

        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)

            anaDocumentoAllegatoService.saveAllegatoLocale(allegato, contenutoAllegato)
            caricaDettaglio()

            throw dre
        } catch (Exception ex) {
            log.error(ex.message, ex)

            anaDocumentoAllegatoService.delete(allegato)

            throw ex
        }

        refreshUi()
    }

    @Command
    void onScanDocumentoAllegato(@ContextParam(ContextType.TRIGGER_EVENT) ScanEvent event) {
        String nomeAllegato = event.filename
        byte[] fileContent = event.inputStream.bytes
        Map<String, String> etichettaErrore = FileUtils.checkFile(fileContent, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (etichettaErrore) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(etichettaErrore))
            return
        }
        salvaAllegato(nomeAllegato, fileContent)

    }

    @Command
    void onDownloadAllegato(@BindingParam("allegato") AnaDocumentoAllegato allegato) {
        anaDocumentoAllegatoService.downloadAllegato(allegato)
    }

    @Command
    void onEliminaAllegato(@BindingParam("allegato") AnaDocumentoAllegato allegato) {
        Messagebox.show(allegato.nome + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Allegato")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK.equals(e.getName())) {
                            anaDocumentoAllegatoService.delete(allegato)
                            caricaDettaglio()
                            if (allegatoLista.size() == 0) {
                                anaDocumentoAllegatoService.deleteDocumento(allegato)
                            }
                        }
                    }
                }
        )

    }

    @Command
    void onEditaNote(@BindingParam("allegato") AnaDocumentoAllegato allegato) {
        Window w = (Window) Executions.createComponents("/restrict/afc/popupNote.zul", self, [allegato: allegato, serviceBeanName: "anaDocumentoAllegatoService"])
        w.addEventListener(CustomEvents.ON_CLOSE_RELOAD, { e ->
            caricaDettaglio()
        })
        w.doModal()
    }

    @Command
    void onShowInfo(@BindingParam("allegato") AnaDocumentoAllegato allegato) {
        String message
        if (allegato.terminalista != null || allegato.dataRegistrazione != null) {
            message = "${getEtichetta(Etichette.getEtichetta("Terminalista"))}: ${allegato.terminalista?.nominativo ?: ""}\n${getEtichetta(Etichette.getEtichetta("Data_Registrazione"))}: ${DataUtils.fromDateToString(allegato.dataRegistrazione)}"
        } else {
            message = getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile"))
        }

        Messagebox.show(message, msgTitle, Messagebox.OK, Messagebox.INFORMATION)
    }

}
