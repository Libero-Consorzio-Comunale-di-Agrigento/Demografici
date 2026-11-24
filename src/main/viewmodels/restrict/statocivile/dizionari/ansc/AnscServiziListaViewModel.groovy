package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnscServiziListaViewModel extends DizionarioListaViewModel{

    List<AnscEndPointServizio> lista
    AnscEndPointServizio dettaglio

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnscEndPointServizioService anscEndPointServizioService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        addEnabled = true
        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Funzione_non_abilitata"), Etichette.getEtichetta("Archivio"), Etichette.getEtichetta("Servizi_Ansc")]

        eList.addAll(AnscEndPointServizio.etichetteDomain)

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Servizio_crescente"), Etichette.getEtichetta("Servizio_decrescente")])

        doInitEtichette(eList)

        totalSizeLabel = ""

        msgTitle = getEtichetta(Etichette.getEtichetta("Servizi_Ansc"))

        formLabel = msgTitle?.toUpperCase()

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Servizio_crescente")), [new Sort.Order(Sort.Direction.ASC, "servizio")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Servizio_decrescente")), [new Sort.Order(Sort.Direction.DESC, "servizio")])])

        selectedOrder = listaOrder[0]

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

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page<AnscEndPointServizio> p = anscEndPointServizioService.listAllByServizioOrDescrizioneLike(SqlUtils.beginsAndEndsLike(filtro), pr)

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/ansc/anscServiziDettaglio.zul"
    }

    @Command void onModifica(){
        if (dettaglio && userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
        }
    }

    @Command void onInserisci() {
        if (userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), [:])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio) {
            return (dettaglio.descrizioneEstesa + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            anscEndPointServizioService.delete(dettaglio)
            onRicarica()
        }
    }

}
