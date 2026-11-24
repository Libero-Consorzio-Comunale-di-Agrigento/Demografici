package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.AnaDettaglioProvvedimento
import it.finmatica.de4gsdzk.anagrafe.AnaProvvedimentoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaProvvedimentoAnagrafeService
import it.finmatica.de4gsdzk.anagrafe.AnaVariazioneAnagrafe
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitControlBarCapable

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ProvvedimentoListaViewModel extends AbstractListaViewModel implements TraitControlBarCapable, TraitIndividuoCorrente {

    List<AnaProvvedimentoAnagrafe> lista
    AnaProvvedimentoAnagrafe dettaglio

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    boolean provvedimento = true

    @WireVariable
    private AnaProvvedimentoAnagrafeService anaProvvedimentoAnagrafeService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        controlBarAttributes.pagingEnabled = false
        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Provvedimenti")]

        // Aggiungo etichette entità
        eList.addAll(AnaVariazioneAnagrafe.etichetteDomain)
        eList.addAll(AnaDettaglioProvvedimento.etichetteDomain)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        eList.addAll([Etichette.getEtichetta("Warn_Nessun_elemento_selezionato"), Etichette.getEtichetta("Ordina_per")])

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Provvedimenti"))

        formLabel = msgTitle?.toUpperCase()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Evento")), SortUtils.dataAnaEventoAsc))
        selectedOrder = listaOrder[0]

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
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
        List<AnaProvvedimentoAnagrafe> l = anaProvvedimentoAnagrafeService.findAllByAnagrafe(individuoCorrente, pr).content

        return new Paginazione((l ?: []), (l.size() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshUi()
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


}
