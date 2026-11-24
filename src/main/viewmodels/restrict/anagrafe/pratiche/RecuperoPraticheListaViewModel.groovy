package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaRecuperoPraticaBaseDomain
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaRecuperoPraticaService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RecuperoPraticheListaViewModel extends AbstractListaViewModel {

    List<AnaRecuperoPraticaBaseDomain> lista
    AnaRecuperoPraticaBaseDomain dettaglio

    String archivio

    final List<ETipoAnagrafe> listaTipoArchivioPratica = [ETipoAnagrafe.RESIDENTI]
    final List<ETipoPratica> listaTipoPratica = [ETipoPratica.ISC, ETipoPratica.VAR]
    ETipoPratica tipoPratica

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private AnaRecuperoPraticaService anaRecuperoPraticaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("archivio") String a) {
        self = w
        archivio = a

        List<Map<String, String>> eList = [Etichette.getEtichetta("Recupero_Pratiche_ANPR"), Etichette.getEtichetta("Recupero_Pratiche_Web")]
        eList.addAll(AnaRecuperoPraticaBaseDomain.etichetteDomain)
        eList.addAll(ETipoAnagrafe.values()*.getEtichettaDesc())
        eList.addAll(ETipoPratica.values()*.getEtichettaDesc())

        eList.addAll([Etichette.getEtichetta("Nessuna_Pratica_Presente"), Etichette.getEtichetta("Ask_Modifiche_In_Sospeso"),
                      Etichette.getEtichetta("back_tooltip"), Etichette.getEtichetta("seleziona_tooltip"), Etichette.getEtichetta("scarica_documenti_tooltip"),
                      Etichette.getEtichetta("Chiusura"), Etichette.getEtichetta("Numero_record_trovati"), Etichette.getEtichetta("Tutti")])

        eList.addAll(Etichette.getEtichetta("filtro_ricerca_placeholder"), Etichette.getEtichetta("ricerca_tooltip"),
                     Etichette.getEtichetta("filtro_ricerca_tooltip"), Etichette.getEtichetta("Funzione_non_disponibile"))

        eList.addAll([Etichette.getEtichetta("Ordina_per"),
                      Etichette.getEtichetta("Data_Inoltro_decrescente"),
                      Etichette.getEtichetta("Data_Inoltro_crescente")])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        if (archivio == 'ANPR') {
            listaTipoPratica.addAll([ETipoPratica.RET, null])
        } else {
            listaTipoPratica.add(null)
        }

        msgTitle = archivio == 'WEB' ? getEtichetta(Etichette.getEtichetta("Recupero_Pratiche_Web")) : getEtichetta(Etichette.getEtichetta("Recupero_Pratiche_ANPR"))
        formLabel = msgTitle?.toUpperCase()
        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Inoltro_crescente")), SortUtils.dataInoltroAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Inoltro_decrescente")), SortUtils.dataInoltroDesc)])

        selectedOrder = listaOrder[0]

        caricaLista()

        if (lista.size() == 0) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessuna_Pratica_Presente")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                onBackFromList()
                            }
                        }
                    })
        }

    }

    @Override
    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    @Override
    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page p = anaRecuperoPraticaService.findAllByTipoPraticaAndFiltroLike(tipoPratica, filtro, archivio, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    @Command
    void onBackFromList() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Command
    void selectTipoPratica() {
        onRicarica()
    }

    @Command
    void onDownloadDocumenti(@BindingParam("pratica") AnaRecuperoPraticaBaseDomain pratica) {
        anaRecuperoPraticaService.downloadDocumenti(pratica)
    }

    @Command
    void onSeleziona(@BindingParam("pratica") AnaRecuperoPraticaBaseDomain pratica) {
        if(pratica.tipoPratica == ETipoPratica.VAR) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            return
        }
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/popupRecuperoPratica.zul", self, [archivio: archivio, pratica: pratica])
        w.addEventListener(Events.ON_CLOSE, { event ->
            onRicarica()
        })
        w.doModal()
    }
}
