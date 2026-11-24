package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivMotivoRichiesta
import it.finmatica.de4gsdzk.statocivile.CivMotivoRichiestaService
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
class MotivoRichiestaListaViewModel extends DizionarioListaViewModel{

    List<ETipoAtto> listaTipiAtto
    ETipoAtto tipoAttoEnum

    CivMotivoRichiesta dettaglio
    List<CivMotivoRichiesta> lista

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @WireVariable
    private CivMotivoRichiestaService civMotivoRichiestaService

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {

        self = w

        pagingEnabled = false
        searchEnabled = true
        addEnabled = false


        List<Map> eList = [Etichette.getEtichetta("Motivi_richiesta"), Etichette.getEtichetta("Funzione_non_abilitata"), Etichette.getEtichetta("Tipi_di_Atto")]
        eList.addAll(CivMotivoRichiesta.etichetteDomain)
        eList.addAll(ETipoRichiesta.values()*.getEtichettaDesc())

        listaTipiAtto = [ETipoAtto.NAS, ETipoAtto.CIT]
        eList.addAll(listaTipiAtto*.getEtichettaPluralDesc())

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Motivi_richiesta"))

        resize()

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), SortUtils.idAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), SortUtils.idDesc)])

        selectedOrder = listaOrder[0]

    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    @Command void onSelectTipoAtto() {
        onRicarica()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
        Page<CivMotivoRichiesta> p = civMotivoRichiestaService.listAllByDescrizioneLike(filtro, pr, [tipoAttoEnum: tipoAttoEnum])
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/ansc/motivoRichiestaDettaglio.zul"
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

}
