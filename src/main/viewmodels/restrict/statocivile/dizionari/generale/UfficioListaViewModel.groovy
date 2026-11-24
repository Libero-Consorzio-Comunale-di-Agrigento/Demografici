package restrict.statocivile.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivUfficio
import it.finmatica.de4gsdzk.statocivile.CivUfficioService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.OrderBy
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SortUtils
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
class UfficioListaViewModel extends DizionarioListaViewModel{

    CivUfficio dettaglio
    List<CivUfficio> lista

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CivUfficioService civUfficioService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Uffici"), Etichette.getEtichetta("Funzione_non_abilitata")]
        eList.addAll(CivUfficio.etichetteDomain)

        eList.addAll([Etichette.getEtichetta("Ufficio_crescente"), Etichette.getEtichetta("Ufficio_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Uffici"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Ufficio_crescente")), SortUtils.idAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Ufficio_decrescente")), SortUtils.idDesc)])

        selectedOrder = listaOrder[0]

        caricaLista()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page<CivUfficio> p = civUfficioService.listAllBySedeLike(filtro, pr)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/generale/ufficioDettaglio.zul"
    }

    @Command onInserisci() {
        if (addEnabled && userModifyEnabled){
            apriDettaglio(getUriDettaglio(), [:])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command onModifica() {
        if (modifyEnabled && dettaglio){
            if (userModifyEnabled){
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getMessaggioCancellazione(){
        return ""
    }

    void eliminaRecord() {
        log.info("WIP")
        //Da ragionare: è consentito cancellare gli uffici?
        /*
        if (deleteEnabled && dettaglio){
            civUfficioService.delete(dettaglio)
            onRicarica()
        }
        */
    }

}
