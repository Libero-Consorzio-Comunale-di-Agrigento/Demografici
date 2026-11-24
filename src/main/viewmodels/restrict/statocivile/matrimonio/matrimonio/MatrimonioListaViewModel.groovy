package restrict.statocivile.matrimonio.matrimonio

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IAttoMatUci
import it.finmatica.de4gsdzk.statocivile.CivMatrimonio
import it.finmatica.de4gsdzk.statocivile.CivMatrimonioService
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivTipoAttoService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.AttoListaParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MatrimonioListaViewModel extends AttoListaParentViewModel{

    List<ETipoEvento> listaTipi = []

    List<Map> addPlusCustomList = []

    @WireVariable
    private CivMatrimonioService civMatrimonioService

    @WireVariable
    private CivTipoAttoService civTipoAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        addEnabled = false
        addPlusEnabled = true
        modifyEnabled = false
        addCustomEnabled = true
        printEnabled = false
        csvExportEnabled = true
        excelExportEnabled = true
        filtriExtraEnabled = true
        additionalSearchFilter  = "/restrict/afc/statoAttoListaSearch.zul"
        additionalSearchFilter2 = "/restrict/afc/tipoMatUciListaSearch.zul"

        ricercaAtto = new RicercaAtto(ETipoAtto.MAT)

        List<Map<String, String>> eList = [Etichette.getEtichetta("Atti_Matrimonio"), Etichette.getEtichetta("Data_Evento"),
                                           Etichette.getEtichetta("Generalita_Sposo_decrescente"), Etichette.getEtichetta("Generalita_Sposo_crescente"),
                                           Etichette.getEtichetta("Generalita_Sposa_decrescente"), Etichette.getEtichetta("Generalita_Sposa_crescente")]

        eList.addAll(CivMatrimonio.etichetteDomain)

        listaTipi = [ETipoEvento.Matrimoni, ETipoEvento.Divorzi]
        eList.addAll(listaTipi*.etichettaDesc)
        listaTipi.add(0, null)

        doInit(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Atti_Matrimonio"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        onCaricaTipiAttoByCategoria()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Estremi_Atto_decrescente")),            SortUtils.estremiAttoDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Estremi_Atto_crescente")),              SortUtils.estremiAttoAsc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_Sposo_decrescente")),        SortUtils.cognomeNomeConiuge1Desc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_Sposo_crescente")),          SortUtils.cognomeNomeConiuge1Asc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_Sposa_decrescente")),        SortUtils.cognomeNomeConiuge2Desc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_Sposa_crescente")),          SortUtils.cognomeNomeConiuge2Asc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Evento_decrescente")),             SortUtils.dataEventoDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Evento_crescente")),               SortUtils.dataEventoAsc ))

        //Default: estremi atto discendente
        selectedOrder = listaOrder[0]

        resize()
    }

    @GlobalCommand('onLoadSezione')
    @Command void onCaricaTipiAttoByCategoria() {
        addPlusList = []
        addPlusCustomList = []

        Integer ta = new Integer(ETipoAtto.MAT.valore)

        addPlusList = getAddMenu(ta, NaturaUtils.getValoriMatrimonio(), [:])
        BindUtils.postNotifyChange(null, null, this, "addPlusList")

        addPlusCustomList = getAddMenu(ta, NaturaUtils.getValoriDivorzio(), [flagDivorzio: true])
        addPlusCustomList = addPlusCustomList.sort { it ->
            switch (it.tipo) {
                case CivTipoAtto.TIPO_CATEGORIA:
                    return 0
                case CivTipoAtto.TIPO_BASE:
                    return 1
                case CivTipoAtto.TIPO_PREGRESSO:
                    return 2
                default:
                    return 3
            }
        }
        BindUtils.postNotifyChange(null, null, this, "addPlusCustomList")
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Map params = [ activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                       ufficio: ricercaAtto.ufficio, anno: ricercaAtto.anno, parte: ricercaAtto.parte, serie: ricercaAtto.serie,
                       atto: ricercaAtto.atto, dataMatrimonio: ricercaAtto.dataEvento, stato: ricercaAtto.stato, tipo: ricercaAtto.tipo,
                       cognome: ricercaAtto.cognome, nome: ricercaAtto.nome, idAttoAnsc: ricercaAtto.idAttoAnsc,
                       comunicazioniPendenti: ricercaAtto.comunicazioniPendenti, order : selectedOrder?.campi]

        Page p = civMatrimonioService.list(params)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    String getUriDettaglio(ETipoOperazione tipoOperazione){
        if (tipoOperazione == ETipoOperazione.INS) {
            return uriDettaglioMatrimonio
        } else {
            if (((IAttoMatUci) dettaglio).divorzio) {
                return uriDettaglioDivorzio
            }
            return uriDettaglioMatrimonio
        }
    }

    String getUriDettaglioPregresso(ETipoOperazione tipoOperazione){
        if (tipoOperazione == ETipoOperazione.INS) {
            return uriDettaglioMatrimonioPregresso
        } else {
            if (((IAttoMatUci) dettaglio).divorzio) {
                return uriDettaglioDivorzioPregresso
            }
            return uriDettaglioMatrimonioPregresso
        }
    }

    static final String uriDettaglioMatrimonio = "/restrict/statocivile/matrimonio/matrimonio/matrimonioDettaglio.zul"
    static final String uriDettaglioMatrimonioPregresso = "/restrict/statocivile/matrimonio/matrimonio/matrimonioPregressoDettaglio.zul"
    static final String uriDettaglioDivorzio = "/restrict/statocivile/matrimonio/matrimonio/divorzioDettaglio.zul"
    static final String uriDettaglioDivorzioPregresso = "/restrict/statocivile/matrimonio/matrimonio/divorzioPregressoDettaglio.zul"

    @Command void onInserisciCustomPlus(@BindingParam("idDomain") Integer idTipoAttoDomain) {
        if (addCustomEnabled && idTipoAttoDomain){
            if (userModifyEnabled) {
                CivTipoAtto ta = civTipoAttoService.get(idTipoAttoDomain)
                Map params = [tipoAttoDomain: ta]
                apriDettaglio(uriDettaglioDivorzio, params)
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.MAT
    }

}
