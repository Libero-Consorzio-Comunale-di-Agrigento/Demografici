package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoNonResidenteFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteEsteroFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.TraitControlBarCapable

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FamigliaStoricoListaViewModel extends AbstractMasterDetailSituazioneStoricoFamigliaListaViewModel implements TraitControlBarCapable, TraitIndividuoCorrente {

    List<AnaFamiglia> famigliaList
    AnaFamiglia famiglia

    List<AnaEventoFamiglia> lista
    AnaEventoFamiglia dettaglio

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    @WireVariable
    private AnaFamigliaService anaFamigliaService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        controlBarAttributes.pagingEnabled = false
        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Storico"), Etichette.getEtichetta("Famiglia"), Etichette.getEtichetta("Situazione_al")]

        // Aggiungo etichette entità
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnaFamiglia.etichetteDomain)
        eList.addAll(AnaEventoFamiglia.etichetteDomain)
        eList.addAll(AnaEventoAnagrafeFamiglia.etichetteDomain)
        eList.addAll(IndirizzoResidenteFamiglia.etichetteDomain)
        eList.addAll(IndirizzoResidenteEsteroFamiglia.etichetteDomain)
        eList.addAll(IndirizzoNonResidenteFamiglia.etichetteDomain)
        eList.addAll(EFascia.values()*.etichettaPluralDesc)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll([Etichette.getEtichetta("allegati_tooltip")])

        eList.addAll([Etichette.getEtichetta("Warn_Nessun_elemento_selezionato")])

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = "${getEtichetta(Etichette.getEtichetta("Storico"))} ${getEtichetta(Etichette.getEtichetta("Famiglia"))}"

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        resize()

        caricaFamiglieList()

        caricaFamiglia(famigliaList[0]?.id)

        caricaLista()
    }

    private void caricaFamiglieList() {
        famigliaList = anaAnagrafeService.listAllFamiglieById(individuoCorrente.id)
    }

    private void caricaFamiglia(String id) {
        this.famiglia = anaFamigliaService.findById(id)
        refreshUi()
    }

    @Command
    void onSelectFamiglia() {
        caricaFamiglia(famiglia?.id)
        caricaLista()
        resetDettaglio()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = (p.lista as List<AnaEventoFamiglia>).sort(false) { it.dataEvento}
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(SortUtils.idAsc))

        Page<AnaEventoFamiglia> p = anaFamigliaService.findAllEventoFamigliaById(famiglia.id, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        eventoAnagrafeFamigliaList = []
        refreshUi()
    }

    void resetLista() {
        lista = []
        refreshLista()
    }

    @Command
    void onSelectDettaglio() {
        caricaListaEventoAnagrafeFamiglia(famiglia, dettaglio?.dataEvento)
    }

    @Command
    void onOpenAllegati() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/famigliaAllegatiLista.zul", self.parent, [famiglia: famiglia])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form famiglia allegati", ex)
            throw ex
        }
    }

}
