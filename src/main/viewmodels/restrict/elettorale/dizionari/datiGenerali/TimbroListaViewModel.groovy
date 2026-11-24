package restrict.elettorale.dizionari.datiGenerali

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.elettorale.EleTimbro
import it.finmatica.de4gsdzk.elettorale.EleTimbroService
import it.finmatica.de4gsdzk.utils.ETipoLista
import it.finmatica.de4gsdzk.utils.OrderBy
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
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
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class TimbroListaViewModel extends DizionarioListaViewModel {

    EleTimbro dettaglio
    List<EleTimbro> lista

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private EleTimbroService eleTimbroService

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Timbri"), Etichette.getEtichetta("Funzione_non_abilitata")]
        eList.addAll(EleTimbro.etichetteDomain)
        eList.addAll(ETipoLista.values()*.getEtichettaDesc())

        eList.addAll([Etichette.getEtichetta("Tipo_Timbro_decrescente"), Etichette.getEtichetta("Tipo_Timbro_crescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Timbri"))
        formLabel = msgTitle?.toUpperCase()
        totalSizeLabel = ""

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Tipo_Lista")),    [new Sort.Order(Sort.Direction.DESC, "tipoLista")]))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Tipo_Timbro_crescente")),      [new Sort.Order(Sort.Direction.ASC, "tipo")]))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Tipo_Timbro_decrescente")),    [new Sort.Order(Sort.Direction.DESC, "tipo")]))

        selectedOrder = listaOrder[0]
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
        Page<EleTimbro> p = eleTimbroService.listAllByFiltroLike(filtro, pr)
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/elettorale/dizionari/datiGenerali/timbroDettaglio.zul"
    }

    @Command
    void onInserisci() {
        if (addEnabled && userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), [:])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command
    void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getMessaggioCancellazione() {
        if (dettaglio) {
            return (dettaglio?.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio) {
            eleTimbroService.delete(dettaglio)
            onRicarica()
        }
    }
}
