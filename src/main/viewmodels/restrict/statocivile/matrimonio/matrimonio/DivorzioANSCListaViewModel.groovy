package restrict.statocivile.matrimonio.matrimonio

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivMatrimonio
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
class DivorzioANSCListaViewModel extends AnscAttoListaParentViewModel {

    @Delegate
    ControlBarANSCAttributes cbANSC = new ControlBarANSCAttributes()

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("pkAtto") Long pkAtto,
         @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
         @ExecutionArgParam("casoUso") AnscCasoUsoBaseDomain casoUso) {
        self = w

        backFromListANSCEnabled = true

        List<Map> eList = [Etichette.SEZIONE_DATI_MATRIMONIO, Etichette.SEZIONE_SPOSO, Etichette.SEZIONE_SPOSA]

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
        CivMatrimonio matrimonio = (CivMatrimonio)atto

        Map params = [parte: matrimonio.parte,
                      serie: matrimonio.serie,
                      categoria: matrimonio.tipoAttoDomain?.categoriaDomain?.codice,
                      tipoAttoAnsc: matrimonio.getTipoAttoAnsc(),
                      divorzio: Boolean.TRUE]
        params.put("tipoDivorzio", datiProvenienza.tipoDivorzio)
        params.put("tipoDivorzioAltro", datiProvenienza.tipoDivorzioAltro)
        return params
    }

    /*
    refs #71063
    Gestione spostata nel parent per implementazione attestazione di conformità
    String getTipoDocumentoCdu(){
        CivMatrimonio matrimonio = (CivMatrimonio)atto
        if (matrimonio.isAvvocati()){
            return datiProvenienza?.tipoProvvedimentoAutoritaGiudiziaria?.name()
        }
        return null
    }
    */

}


