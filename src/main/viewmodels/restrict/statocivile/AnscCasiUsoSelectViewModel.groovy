package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoBaseDomain
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoService
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnscCasiUsoSelectViewModel extends AbstractSelectViewModel {

    List<AnscCasoUsoBaseDomain> lista
    AnscCasoUsoBaseDomain dettaglio

    ETipoAtto tipoAttoEnum
    ETipoAttoAnsc tipoAttoAnsc
    CivCategoriaTipoAtto categoria

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnscCasoUsoService anscCasoUsoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
               @ExecutionArgParam("categoria") CivCategoriaTipoAtto categoria, @ExecutionArgParam("tipoAttoAnsc") ETipoAttoAnsc tipoAttoAnsc){
        self = w

        addEnabled = false
        modifyEnabled = false
        searchEnabled = true

        List<Map> eList = [Etichette.getEtichetta("ANSC")]
        eList.addAll(AnscCasoUsoBaseDomain.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("ANSC"))

        totalSizeLabel = ""

        this.tipoAttoEnum = tipoAttoEnum
        this.tipoAttoAnsc = tipoAttoAnsc
        this.categoria = categoria

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(SortUtils.descrizioneAsc))

        // Recupero solo quelli con il flag_visibile a 'S'
        String f = (filtro?SqlUtils.beginsAndEndsLike(filtro):"%")
        Page p = anscCasoUsoService.listAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(tipoAttoEnum, categoria, tipoAttoAnsc, f, pr)

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    @Command void onSeleziona() {
        if (dettaglio){
            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, [casoUso: dettaglio] )
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

}
