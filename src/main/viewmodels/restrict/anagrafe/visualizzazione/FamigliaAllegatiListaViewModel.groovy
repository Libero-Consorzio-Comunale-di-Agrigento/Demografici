package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.*
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

import javax.persistence.criteria.JoinType
import java.nio.charset.StandardCharsets

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FamigliaAllegatiListaViewModel extends AbstractListaViewModel implements TraitControlBarCapable, TraitIndividuoCorrente {

    List<AnaFamigliaAllegato> lista
    AnaFamigliaAllegato dettaglio

    AnaFamiglia famiglia
    boolean readOnly = false

    @WireVariable
    private AnaFamigliaService anaFamigliaService

    @WireVariable
    private AnaFamigliaAllegatoService anaFamigliaAllegatoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("famiglia") AnaFamiglia famiglia) {
        self = w

        this.famiglia = anaFamigliaService.get(famiglia.id,
                [fetch: [[campo: 'allegati', tipo: JoinType.LEFT]]])

        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Allegati_Famiglia")]

        // Aggiungo etichette entità
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnaFamiglia.etichetteDomain)
        eList.addAll(AnaFamigliaAllegato.etichetteDomain)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarAttributes.etichetteCbDesc)
        eList.addAll([Etichette.getEtichetta("inserisci_allegato_tooltip"), Etichette.getEtichetta("scarica_allegato_tooltip"), Etichette.getEtichetta("scarica_allegati_tooltip"), Etichette.getEtichetta("info_tooltip"), Etichette.getEtichetta("elimina_tooltip")])

        // Aggiungo etichette order
        eList.addAll([Etichette.getEtichetta("Data_emissione_decrescente"), Etichette.getEtichetta("Data_emissione_crescente")])

        eList.addAll([Etichette.getEtichetta("Warn_Nessun_elemento_selezionato")])

        // Aggiungo etichette per messaggi restituiti da upload
        eList.addAll(FileUtils.etichetteFileUtils)

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([Etichette.getEtichetta("Errore_nome_allegato_esistente")])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Allegati_Famiglia"))
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

        Page p = anaFamigliaAllegatoService.listAllByFamiglia(famiglia, pr)
        famiglia.allegati = new ArrayList(p?.getContent() ?: [])

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
        AnaFamigliaAllegato allegato = anaFamigliaAllegatoService.create(famiglia, nomeAllegato)
        anaFamigliaAllegatoService.save(allegato)

        try {
            anaFamigliaAllegatoService.saveAllegatoDocumentale(allegato, contenutoAllegato)
            caricaLista()
        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)

            anaFamigliaAllegatoService.saveAllegatoLocale(allegato, contenutoAllegato)
            caricaLista()

            throw dre
        } catch (Exception ex) {
            log.error(ex.message, ex)

            anaFamigliaAllegatoService.delete(allegato)

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
    void onDownloadAllegato(@BindingParam("allegato") AnaFamigliaAllegato allegato) {
        anaFamigliaAllegatoService.downloadAllegato(allegato)
    }

    @Command
    void onEliminaAllegato(@BindingParam("allegato") AnaFamigliaAllegato allegato) {
        Messagebox.show(allegato.nome + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Allegato")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK.equals(e.getName())) {
                            anaFamigliaAllegatoService.delete(allegato)
                            caricaLista()
                            if(famiglia.allegati.size() == 0) {
                                anaFamigliaAllegatoService.deleteDocumento(allegato)
                            }
                        }
                    }
                }
        )

    }

    @Command
    void onDownloadAllegati() {
        anaFamigliaAllegatoService.downloadAllegati(famiglia)
    }

    @Command
    void onEditaNote(@BindingParam("allegato") AnaFamigliaAllegato allegato) {
        Window w = (Window) Executions.createComponents("/restrict/afc/popupNote.zul", self, [allegato: allegato, serviceBeanName: "anaFamigliaAllegatoService"])
        w.addEventListener(CustomEvents.ON_CLOSE_RELOAD, { e ->
            refreshUi()
        })
        w.doModal()
    }

    @Command void onShowInfo(@BindingParam("allegato") AnaFamigliaAllegato allegato) {
        String message
        if (allegato.terminalista != null || allegato.dataRegistrazione != null) {
            message ="${getEtichetta(Etichette.getEtichetta("Terminalista"))}: ${allegato.terminalista?.nominativo ?: ""}\n${getEtichetta(Etichette.getEtichetta("Data_Registrazione"))}: ${DataUtils.fromDateToString(allegato.dataRegistrazione)}"
        } else {
            message = getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile"))
        }

        Messagebox.show(message, msgTitle, Messagebox.OK, Messagebox.INFORMATION)
    }

}
