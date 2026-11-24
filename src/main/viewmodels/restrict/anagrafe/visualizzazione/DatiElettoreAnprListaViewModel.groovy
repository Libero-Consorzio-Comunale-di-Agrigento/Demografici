package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.AnpElettoraleService
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.anpr.AnpElettorale
import it.finmatica.de4gsdzk.utils.*
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
class DatiElettoreAnprListaViewModel extends AbstractListaViewModel implements TraitControlBarCapable, TraitIndividuoCorrente {

    List<AnpElettorale> lista
    AnpElettorale dettaglio
    AnpAnagrafe anpSoggetto

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private AnpElettoraleService anpElettoraleService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        controlBarAttributes.pagingEnabled = false
        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Dati_Elettore_ANPR")]

        // Aggiungo etichette entità
        eList.addAll(AnpAnagrafe.etichetteDomain)
        eList.addAll(AnpElettorale.etichetteDomain)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        eList.addAll([Etichette.getEtichetta("Warn_Nessun_elemento_selezionato"), Etichette.getEtichetta("Errore_Ricerca_ANPR")])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Dati_Elettore_ANPR"))

        formLabel = msgTitle?.toUpperCase()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Ordine_Lista")), SortUtils.ordineLista))
        selectedOrder = listaOrder[0]

        totalSizeLabel = ""

        resize()

        anpSoggetto = anprIndividuoCorrente
        caricaLista()

    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    @Override
    void resetDettaglio() {

    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
        List<AnpElettorale> l = anpElettoraleService.findAllByIdOperazione(anpSoggetto.idOperazione, pr).content

        return new Paginazione((l ?: []), (l.size() ?: 0))
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


}
