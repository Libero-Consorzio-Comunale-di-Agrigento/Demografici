package restrict.statocivile.nascita

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivNascita
import it.finmatica.de4gsdzk.statocivile.CivNascitaService
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
class NascitaListaViewModel extends AttoListaParentViewModel{

    @WireVariable
    private CivNascitaService civNascitaService

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

        ricercaAtto = new RicercaAtto(ETipoAtto.NAS)

        List<Map<String, String>> eList = [Etichette.Atti_Nascita, Etichette.Generalita_decrescente, Etichette.Generalita_crescente]

        eList.addAll(CivNascita.etichetteDomain)

        doInit(eList)

        msgTitle = getEtichetta(Etichette.Atti_Nascita)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        onCaricaTipiAttoByCategoria()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_decrescente),            SortUtils.estremiAttoDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_crescente),              SortUtils.estremiAttoAsc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_decrescente),              SortUtils.cognomeNomeNatoDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_crescente),                SortUtils.cognomeNomeNatoAsc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Evento_decrescente),             SortUtils.dataEventoDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Evento_crescente),               SortUtils.dataEventoAsc ))

        //Default: estremi atto discendente
        selectedOrder = listaOrder[0]

        resize()
    }

    @GlobalCommand('onLoadSezione')
    @Command void onCaricaTipiAttoByCategoria() {
        addPlusList = []

        Integer ta = new Integer(ETipoAtto.NAS.valore)
        addPlusList = getAddMenu(ta, NaturaUtils.getValoriNascita(), [:])

        BindUtils.postNotifyChange(null, null, this, "addPlusList")
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Map params = [ activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                       ufficio: ricercaAtto.ufficio, anno: ricercaAtto.anno, parte: ricercaAtto.parte, serie: ricercaAtto.serie,
                       atto: ricercaAtto.atto, dataNascita: ricercaAtto.dataEvento, stato: ricercaAtto.stato,
                       cognome: ricercaAtto.cognome, nome: ricercaAtto.nome, idAttoAnsc: ricercaAtto.idAttoAnsc,
                       comunicazioniPendenti: ricercaAtto.comunicazioniPendenti, order : selectedOrder?.campi]

        Page p = civNascitaService.list(params)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    String getUriDettaglio(ETipoOperazione tipoOperazione){
        if ( (tipoOperazione != ETipoOperazione.INS) && (tipoOperazione != ETipoOperazione.UPD) ) {
            return ""
        }
        return "/restrict/statocivile/nascita/nascitaDettaglio.zul"
    }

    String getUriDettaglioPregresso(ETipoOperazione tipoOperazione){
        if ( (tipoOperazione != ETipoOperazione.INS) && (tipoOperazione != ETipoOperazione.UPD) ) {
            return ""
        }
        return "/restrict/statocivile/nascita/nascitaPregressoDettaglio.zul"
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.NAS
    }

}
