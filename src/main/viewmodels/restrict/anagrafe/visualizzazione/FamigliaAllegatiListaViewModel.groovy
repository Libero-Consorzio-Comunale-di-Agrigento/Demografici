package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAttributes
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.util.media.Media
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
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
        List<Map<String, String>> eList = [Etichette.Allegati_Famiglia]

        // Aggiungo etichette entità
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnaFamiglia.etichetteDomain)
        eList.addAll(AnaFamigliaAllegato.etichetteDomain)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarAttributes.etichetteCbDesc)
        eList.addAll([Etichette.inserisci_allegato_tooltip, Etichette.scarica_allegato_tooltip])

        // Aggiungo etichette order
        eList.addAll([Etichette.Data_emissione_decrescente, Etichette.Data_emissione_crescente])

        eList.addAll([EtichetteMessaggi.Warn_Nessun_elemento_selezionato])

        // Aggiungo etichette per messaggi restituiti da upload
        eList.addAll(FileUtils.etichetteFileUtils)

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([EtichetteMessaggi.Errore_nome_allegato_esistente])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.Allegati_Famiglia)
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
        Map etichettaErrore = FileUtils.checkFile(fileContent, media.name, FileUtils.defaultAcceptableMimeTypesXAnaDoc)
        if (etichettaErrore) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(etichettaErrore))
            return
        }

        String nome = "AP6_Famiglie_${famiglia.tipoAnagrafe.id}_${famiglia.codice}_${lista.size() + 1}"
        nome = FileUtils.sanitizeFilename(nome)
        nome = "${nome}.${media.format}"

        AnaFamigliaAllegato allegato = anaFamigliaAllegatoService.create(famiglia, nome)
        anaFamigliaAllegatoService.save(allegato)

        try {
            anaFamigliaAllegatoService.saveAllegatoDocumentale(allegato, fileContent)
            caricaLista()
        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)

            anaFamigliaAllegatoService.saveAllegatoLocale(allegato, fileContent)
            caricaLista()

            throw dre
        } catch (Exception ex) {
            log.error(ex.message, ex)

            anaFamigliaAllegatoService.delete(allegato)

            throw ex
        }
    }

    @Command
    void onDownloadAllegato(@BindingParam("allegato") AnaFamigliaAllegato allegato) {
        anaFamigliaAllegatoService.downloadAllegato(allegato)
    }

}
