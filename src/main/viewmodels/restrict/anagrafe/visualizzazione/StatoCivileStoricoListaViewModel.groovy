package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.AnaEventoStatoCivile
import it.finmatica.de4gsdzk.anagrafe.AnaEventoStatoCivileService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitControlBarCapable

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class StatoCivileStoricoListaViewModel extends AbstractListaViewModel implements TraitControlBarCapable, TraitIndividuoCorrente {

    List<AnaEventoStatoCivile> lista
    AnaEventoStatoCivile dettaglio

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @WireVariable
    private AnaEventoStatoCivileService anaEventoStatoCivileService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        controlBarAttributes.pagingEnabled = false
        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.Storico, Etichette.Stato_Civile]

        // Aggiungo etichette entità
        eList.addAll(AnaEventoStatoCivile.etichetteDomain)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)
        eList.addAll(Etichette.Data_Evento)

        eList.addAll([EtichetteMessaggi.Warn_Nessun_elemento_selezionato, Etichette.Ordina_per])

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = "${getEtichetta(Etichette.Storico)} ${getEtichetta(Etichette.Stato_Civile)}"

        formLabel = msgTitle?.toUpperCase()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Evento), SortUtils.dataAnaEventoAsc))
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

        Page<AnaEventoStatoCivile> p = anaEventoStatoCivileService.findAllByAnagrafe(individuoCorrente, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
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

    @Command
    void onOpenConiuge(@BindingParam("soggetto") GsdAnagrafeBaseDomain soggetto) {
        openIndividuo(soggetto)
    }

    private void openIndividuo(GsdAnagrafeBaseDomain soggetto) {
        Events.postEvent(CustomEvents.ON_SELECT_RECORD, self, [soggetto: soggetto])
        onChiudi()
    }

}
