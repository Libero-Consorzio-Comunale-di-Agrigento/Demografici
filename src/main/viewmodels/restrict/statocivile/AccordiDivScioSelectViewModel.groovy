package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAccordoBaseDomain
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.CivAccordoDivorzioService
import it.finmatica.de4gsdzk.statocivile.CivAccordoScioglimentoService
import it.finmatica.de4gsdzk.statocivile.CivMatrimonio
import it.finmatica.de4gsdzk.statocivile.CivUnioneCivile
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AccordiDivScioSelectViewModel extends AbstractRecuperoSelectViewModel {

    List<CivAccordoBaseDomain> lista
    CivAccordoBaseDomain dettaglio

    Boolean anscOn = Boolean.FALSE

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CivAccordoDivorzioService civAccordoDivorzioService

    @WireVariable
    private CivAccordoScioglimentoService civAccordoScioglimentoService

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum){
        self = w

        addEnabled = false
        modifyEnabled = false

        List<Map> eList = [Etichette.getEtichetta("Estremi_Accordo"), Etichette.getEtichetta("Data")]
        eList.addAll(CivMatrimonio.etichetteDomain)
        eList.addAll(CivUnioneCivile.etichetteDomain)
        eList.addAll(CivAttoBaseDomain.etichetteDomain)
        eList.addAll(etichetteRecuperoDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        doInitEtichette(eList)

        etichetteCustom = FormUtils.getAttoCustomLabels(tipoAttoEnum, etichette)

        msgTitle = getEtichetta(Etichette.getEtichetta("Estremi_Accordo"))

        totalSizeLabel = ""

        this.tipoAttoEnum = tipoAttoEnum

        anscOn = arcParametroService.isIntegrazioneAnscAttiva()

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE))

        Page p = null
        switch (tipoAttoEnum) {
            case ETipoAtto.MAT:
                p = civAccordoDivorzioService.listAll(pr)
                break
            case ETipoAtto.UCI:
                p = civAccordoScioglimentoService.listAll(pr)
                break
        }
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    @Command void onSeleziona() {
        if (dettaglio){
            // SOGGETTO 1
            String s1 = checkAnagrafe1(dettaglio)
            if (s1){
                Messagebox.show(s1, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }

            // SOGGETTO 2
            String s2 = checkAnagrafe2(dettaglio)
            if (s2){
                Messagebox.show(s2, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }

            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, [idAccordo: dettaglio.id, idAnagrafe1: dettaglio.idAnagrafe1, idAnagrafe2: dettaglio.idAnagrafe2] )
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
