package restrict.statocivile.unione.unione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivUnioneCivile
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
class ScioglimentoANSCListaViewModel extends AnscAttoListaParentViewModel {

    @Delegate
    ControlBarANSCAttributes cbANSC = new ControlBarANSCAttributes()

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("pkAtto") Long pkAtto,
         @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
         @ExecutionArgParam("casoUso") AnscCasoUsoBaseDomain casoUso) {
        self = w

        backFromListANSCEnabled = true

        List<Map> eList = [Etichette.getEtichetta("SEZIONE_DATI_UNIONE_CIVILE"), Etichette.getEtichetta("SEZIONE_CONTRAENTE_1"), Etichette.getEtichetta("SEZIONE_CONTRAENTE_2")]

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
        CivUnioneCivile uci = (CivUnioneCivile)atto

        Map params = [parte: uci.parte,
                      serie: uci.serie,
                      categoria: uci.tipoAttoDomain?.categoriaDomain?.codice,
                      divorzio: Boolean.TRUE]
        params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
        params.put("tipoDivorzioAltro", datiProvenienza.tipoDivorzioAltro)
        return params
    }

}


