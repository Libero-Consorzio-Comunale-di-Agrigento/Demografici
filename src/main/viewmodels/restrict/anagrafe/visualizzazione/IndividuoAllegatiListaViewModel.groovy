package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeAllegato
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeAllegatoService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAttributes
import it.finmatica.de4gsdzk.zkutils.ScanEvent
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
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
import restrict.TraitControlBarCapable

import java.nio.charset.StandardCharsets

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class IndividuoAllegatiListaViewModel extends AbstractListaViewModel implements TraitControlBarCapable, TraitIndividuoCorrente {

    List<AnaAnagrafeAllegato> lista
    AnaAnagrafeAllegato dettaglio
    boolean readOnly = false

    @WireVariable
    private AnaAnagrafeAllegatoService anaAnagrafeAllegatoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Allegati"), Etichette.getEtichetta("Individuo")]

        // Aggiungo etichette entità
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnaAnagrafeAllegato.etichetteDomain)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarAttributes.etichetteCbDesc)
        eList.addAll([Etichette.getEtichetta("inserisci_allegato_tooltip"), Etichette.getEtichetta("scarica_allegato_tooltip"), Etichette.getEtichetta("scarica_allegati_tooltip"), Etichette.getEtichetta("elimina_allegato_tooltip"), Etichette.getEtichetta("info_tooltip")])

        // Aggiungo etichette order
        eList.addAll([Etichette.getEtichetta("Data_emissione_decrescente"), Etichette.getEtichetta("Data_emissione_crescente")])

        eList.addAll([Etichette.getEtichetta("Warn_Nessun_elemento_selezionato"), Etichette.getEtichetta("Ask_Cancellazione_Allegato")])

        // Aggiungo etichette per messaggi restituiti da upload
        eList.addAll(FileUtils.etichetteFileUtils)

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([Etichette.getEtichetta("Errore_nome_allegato_esistente")])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = "${getEtichetta(Etichette.getEtichetta("Allegati"))} ${getEtichetta(Etichette.getEtichetta("Individuo"))}"
        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        resize()

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(SortUtils.idAsc))

        Page p = anaAnagrafeAllegatoService.listAllByAnagrafe(individuoCorrente, pr)
        individuoCorrente.allegati = new ArrayList(p?.getContent() ?: [])

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
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
    }

    @Command
    void onUploadAllegato(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event) {
        Media media = event.media
        byte[] fileContent = media.isBinary() ? media.byteData : media.stringData.getBytes(StandardCharsets.UTF_8.name())
        Map etichettaErrore = FileUtils.checkFile(fileContent, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (etichettaErrore) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(etichettaErrore))
            return
        }

        salvaAllegato(media.name, fileContent)

    }

    private void salvaAllegato(String nomeAllegato, byte[] contenutoAllegato) {
        AnaAnagrafeAllegato allegato = anaAnagrafeAllegatoService.create(individuoCorrente, nomeAllegato)
        anaAnagrafeAllegatoService.save(allegato)

        try {
            anaAnagrafeAllegatoService.saveAllegatoDocumentale(allegato, contenutoAllegato)
            caricaLista()
        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)

            anaAnagrafeAllegatoService.saveAllegatoLocale(allegato, contenutoAllegato)
            caricaLista()

            throw dre
        } catch (Exception ex) {
            log.error(ex.message, ex)

            anaAnagrafeAllegatoService.delete(allegato)

            throw ex
        }

        refreshUi()
    }


    @Command
    void onScanAllegato(@ContextParam(ContextType.TRIGGER_EVENT) ScanEvent event) {
        String nomeAllegato = event.filename
        byte[] fileContent = event.inputStream.bytes
        Map etichettaErrore = FileUtils.checkFile(fileContent, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (etichettaErrore) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(etichettaErrore))
            return
        }
        salvaAllegato(nomeAllegato, fileContent)

    }

    @Command
    void onDownloadAllegato(@BindingParam("allegato") AnaAnagrafeAllegato allegato) {
        anaAnagrafeAllegatoService.downloadAllegato(allegato)
    }

    @Command
    void onEliminaAllegato(@BindingParam("allegato") AnaAnagrafeAllegato allegato) {
        Messagebox.show(allegato.nome + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Allegato")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK.equals(e.getName())) {
                            anaAnagrafeAllegatoService.delete(allegato)
                            caricaLista()
                            if(individuoCorrente.allegati.size() == 0) {
                                anaAnagrafeAllegatoService.deleteDocumento(allegato)
                            }
                        }
                    }
                }
        )

    }

    @Command
    void onDownloadAllegati() {
        anaAnagrafeAllegatoService.downloadAllegati(individuoCorrente)
    }

    @Command
    void onEditaNote(@BindingParam("allegato") AnaAnagrafeAllegato allegato) {
        Window w = (Window) Executions.createComponents("/restrict/afc/popupNote.zul", self, [allegato: allegato, serviceBeanName: "anaAnagrafeAllegatoService"])
        w.addEventListener(CustomEvents.ON_CLOSE_RELOAD, { e ->
            refreshUi()
        })
        w.doModal()
    }

    @Command void onShowInfo(@BindingParam("allegato") AnaAnagrafeAllegato allegato) {
        String message
        if (allegato.terminalista != null || allegato.dataRegistrazione != null) {
            message ="${getEtichetta(Etichette.getEtichetta("Terminalista"))}: ${allegato.terminalista?.nominativo ?: ""}\n${getEtichetta(Etichette.getEtichetta("Data_Registrazione"))}: ${DataUtils.fromDateToString(allegato.dataRegistrazione)}"
        } else {
            message = getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile"))
        }

        Messagebox.show(message, msgTitle, Messagebox.OK, Messagebox.INFORMATION)
    }


}
