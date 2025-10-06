package restrict.statocivile.cittadinanza

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivCittadinanza
import it.finmatica.de4gsdzk.statocivile.CivCittadinanzaService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.statocivile.AttoListaParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CittadinanzaListaViewModel extends AttoListaParentViewModel{

    @WireVariable
    private CivCittadinanzaService civCittadinanzaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        addEnabled = false
        addPlusEnabled = true
        modifyEnabled = false
        printEnabled = false
        csvExportEnabled = true
        excelExportEnabled = true
        filtriExtraEnabled = true
        additionalSearchFilter = "/restrict/afc/statoAttoListaSearch.zul"

        ricercaAtto = new RicercaAtto(ETipoAtto.CIT)

        List<Map<String, String>> eList = [Etichette.Atti_Cittadinanza, Etichette.Generalita_decrescente, Etichette.Generalita_crescente]

        eList.addAll(CivCittadinanza.etichetteDomain)

        doInit(eList)

        msgTitle = getEtichetta(Etichette.Atti_Cittadinanza)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        onCaricaTipiAttoByCategoria()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_decrescente),            SortUtils.estremiAttoDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_crescente),              SortUtils.estremiAttoAsc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_decrescente),              SortUtils.cognomeNomeDataEventoListaDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_crescente),                SortUtils.cognomeNomeDataEventoListaAsc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Evento_decrescente),             SortUtils.dataEventoDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Evento_crescente),               SortUtils.dataEventoAsc ))

        //Default: estremi atto discendente
        selectedOrder = listaOrder[0]

        resize()
    }

    @GlobalCommand('onLoadSezione')
    @Command void onCaricaTipiAttoByCategoria() {
        addPlusList = []

        Integer ta = new Integer(ETipoAtto.CIT.valore)
        addPlusList = getAddMenu(ta, NaturaUtils.getValoriCittadinanza(), [:])

        BindUtils.postNotifyChange(null, null, this, "addPlusList")
    }

    String getUriDettaglio(ETipoOperazione tipoOperazione){
        if ( (tipoOperazione != ETipoOperazione.INS) && (tipoOperazione != ETipoOperazione.UPD) ) {
            return ""
        }
        return "/restrict/statocivile/cittadinanza/cittadinanzaDettaglio.zul"
    }

    String getUriDettaglioPregresso(ETipoOperazione tipoOperazione){
        if ( (tipoOperazione != ETipoOperazione.INS) && (tipoOperazione != ETipoOperazione.UPD) ) {
            return ""
        }
        return "/restrict/statocivile/cittadinanza/cittadinanzaPregressoDettaglio.zul"
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Map params = [ activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                       ufficio: ricercaAtto.ufficio, anno: ricercaAtto.anno,
                       atto: ricercaAtto.atto, dataGiuramento: ricercaAtto.dataEvento, stato: ricercaAtto.stato,
                       cognome: ricercaAtto.cognome, nome: ricercaAtto.nome, idAttoAnsc: ricercaAtto.idAttoAnsc,
                       comunicazioniPendenti: ricercaAtto.comunicazioniPendenti, order : selectedOrder?.campi]

        Page p = civCittadinanzaService.list(params)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.CIT
    }

}
