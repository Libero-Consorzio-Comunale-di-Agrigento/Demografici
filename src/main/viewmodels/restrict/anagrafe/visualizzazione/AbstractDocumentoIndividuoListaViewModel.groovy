package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAttributes
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.util.media.Media
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
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
    private AnaDocumentoAllegatoService anaDocumentoAllegatoService

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
        eList.addAll([Etichette.Data_emissione_decrescente, Etichette.Data_emissione_crescente])

        eList.addAll([EtichetteMessaggi.Warn_Nessun_elemento_selezionato])

        // Aggiungo etichette funzioni dettaglio
        eList.addAll(EFunzioneDocumento.values()*.getEtichettaDesc())

        // Aggiungo etichette funzioni di ogni riga
        eList.addAll([Etichette.scarica_allegato_tooltip])

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([EtichetteMessaggi.Errore_nome_allegato_esistente])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        totalSizeLabel = ""

        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.Data_emissione_decrescente), SortUtils.dataEmissioneDocumentoDesc),
                           new OrderBy(getEtichetta(Etichette.Data_emissione_crescente), SortUtils.dataEmissioneDocumentoAsc)])

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

    private void caricaDettaglio() {
        funzioniDettaglio.setFunzioni(anaDocumentoService.getFunzioniDocumento(dettaglio))
        allegatoLista = anaDocumentoAllegatoService.listAllByDocumento(dettaglio)
        refreshUi()
    }

    @Command
    void onDownloadDocumento() {
        anaDocumentoService.downloadAllegati(dettaglio)
    }

    @Command
    void onUploadDocumentoAllegato(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event, @BindingParam("documento") AnaDocumento documento) {
        Media media = event.media
        byte[] fileContent = media.isBinary() ? media.byteData : media.stringData.getBytes(StandardCharsets.UTF_8.name())
        Map<String, String> etichettaErrore = FileUtils.checkFile(fileContent, media.name, FileUtils.defaultAcceptableMimeTypesXAnaDoc)
        if (etichettaErrore) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(etichettaErrore))
            return
        }

        AnaDocumentoAllegato allegato = anaDocumentoAllegatoService.create(documento, media.name)
        anaDocumentoAllegatoService.save(allegato)

        try {
            EModelloGdm modello = anaTipoDocumentoService.getModelloGdm(documento.tipoDocumento)
            boolean checkCompetenza = anaTipoDocumentoService.shouldCheckCompetenza(documento.tipoDocumento)

            anaDocumentoAllegatoService.saveAllegatoDocumentale(modello, checkCompetenza, allegato, fileContent)
            caricaDettaglio()

        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)

            anaDocumentoAllegatoService.saveAllegatoLocale(allegato, fileContent)
            caricaDettaglio()

            throw dre
        } catch (Exception ex) {
            log.error(ex.message, ex)

            anaDocumentoAllegatoService.delete(allegato)

            throw ex
        }
    }

    @Command
    void onDownloadDocumentoAllegato(@BindingParam("allegato") AnaDocumentoAllegato allegato) {
        anaDocumentoAllegatoService.downloadAllegato(allegato)
    }

}
