package restrict.statocivile.morte

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivMorte
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarANSCAttributes
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.statocivile.AnscAttoListaParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MorteANSCListaViewModel extends AnscAttoListaParentViewModel {

    @Delegate
    ControlBarANSCAttributes cbANSC = new ControlBarANSCAttributes()

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("pkAtto") Long pkAtto,
         @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
         @ExecutionArgParam("casoUso") AnscCasoUsoBaseDomain casoUso) {
        self = w

        backFromListANSCEnabled = true

        List<Map> eList = [Etichette.getEtichetta("SEZIONE_DECEDUTO")]

        doInitAllAtti(eList, pkAtto, tipoAttoEnum, casoUso, getAttoParams())

        goToAllegatiANSCGrayed = isListServiziAllegatiEmpty()
    }

    Boolean isListServiziAllegatiEmpty() {
        if(casoUso == null){
            return true
        }
        return anscEndPointServizioArchivioService.listAllServiziAttoAllegatiByAndCasoUsoAndAtto(casoUso.id, atto).isEmpty()
    }

    Map getCasoUsoParams(){
        CivMorte morte = (CivMorte)atto
        Map params = [parte: morte.parte,
                      serie: morte.serie,
                      categoria: morte.tipoAttoDomain?.categoriaDomain?.codice,
                      tipoAttoAnsc: morte.getTipoAttoAnsc(),
                      morteViolenta: morte.morteViolenta,
                      estremiDecessoNoti: morte.estremiDecessoNoti]
        if (datiProvenienza.flagExArt19){
            params.put("flagExArt19", datiProvenienza.flagExArt19)
        }
        return params
    }

    /*
    refs #71063
    Gestione spostata nel parent per gestione attestazione di conformità
    String getTipoDocumentoCdu(){
        return datiProvenienza?.tipoTrasmissione?.name()
    }
    */

}

