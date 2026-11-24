package restrict.statocivile.unione.processoVerbale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivProcessoVerbale
import it.finmatica.de4gsdzk.statocivile.CivProcessoVerbaleService
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
class ProcessoVerbaleListaViewModel extends AttoListaParentViewModel{

    @WireVariable
    private CivProcessoVerbaleService civProcessoVerbaleService

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

        ricercaAtto = new RicercaAtto(ETipoAtto.PVU)

        List<Map> eList = [Etichette.getEtichetta("Processi_Verbali"), Etichette.getEtichetta("Generalita_Contraente_1_decrescente"), Etichette.getEtichetta("Generalita_Contraente_1_crescente"),
                           Etichette.getEtichetta("Generalita_Contraente_2_decrescente"), Etichette.getEtichetta("Generalita_Contraente_2_crescente")]

        eList.addAll(CivProcessoVerbale.etichetteDomain)

        doInit(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Processi_Verbali"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        onCaricaTipiAttoByCategoria()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Estremi_Atto_decrescente")),                        SortUtils.estremiAttoDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Estremi_Atto_crescente")),                          SortUtils.estremiAttoAsc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_Contraente_1_decrescente")),             SortUtils.cognomeNomeConiuge1Desc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_Contraente_1_crescente")),               SortUtils.cognomeNomeConiuge1Asc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_Contraente_2_decrescente")),             SortUtils.cognomeNomeConiuge2Desc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_Contraente_2_crescente")),               SortUtils.cognomeNomeConiuge2Asc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Evento_decrescente")),                         SortUtils.dataEventoDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Evento_crescente")),                           SortUtils.dataEventoAsc ))

        //Default: estremi atto discendente
        selectedOrder = listaOrder[0]

        resize()
    }

    @GlobalCommand('onLoadSezione')
    @Command void onCaricaTipiAttoByCategoria() {
        addPlusList = []

        Integer ta = new Integer(ETipoAtto.PVU.valore)
        addPlusList = getAddMenu(ta, NaturaUtils.getValoriProcessoVerbale(), [flagVerbale:true])

        BindUtils.postNotifyChange(null, null, this, "addPlusList")
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Map params = [ activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                       ufficio: ricercaAtto.ufficio, anno: ricercaAtto.anno,
                       atto: ricercaAtto.atto, dataPubblicazione: ricercaAtto.dataEvento, stato: ricercaAtto.stato,
                       cognome: ricercaAtto.cognome, nome: ricercaAtto.nome, comunicazioniPendenti: ricercaAtto.comunicazioniPendenti, order : selectedOrder?.campi]

        Page p = civProcessoVerbaleService.list(params)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    String getUriDettaglio(ETipoOperazione tipoOperazione){
        if ( (tipoOperazione != ETipoOperazione.INS) && (tipoOperazione != ETipoOperazione.UPD) ) {
            return ""
        }
        return "/restrict/statocivile/unione/processoVerbale/processoVerbaleDettaglio.zul"
    }

    String getUriDettaglioPregresso(ETipoOperazione tipoOperazione){
        if ( (tipoOperazione != ETipoOperazione.INS) && (tipoOperazione != ETipoOperazione.UPD) ) {
            return ""
        }
        return "/restrict/statocivile/unione/processoVerbale/processoVerbalePregressoDettaglio.zul"
    }

    @Command void onInserisciPlus(@BindingParam("idDomain") Integer idTipoAttoDomain, @BindingParam("tipo") String tipo) {
        log.info ("Sto gestendo un processo verbale per cui il parametro ${tipo} non serve: non vanno gestiti gli inserimenti di processi verbali pregressi")
        super.onInserisciPlus(idTipoAttoDomain, null)
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.PVU
    }

}
