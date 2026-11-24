package restrict.statocivile.cittadinanza

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivCittadinanza
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

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CittadinanzaANSCListaViewModel extends AnscAttoListaParentViewModel {

    @Delegate
    ControlBarANSCAttributes cbANSC = new ControlBarANSCAttributes()

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("pkAtto") Long pkAtto,
         @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
         @ExecutionArgParam("casoUso") AnscCasoUsoBaseDomain casoUso) {
        self = w

        backFromListANSCEnabled = true

        List<Map> eList = [Etichette.getEtichetta("SEZIONE_RICHIEDENTE")]

        doInitAllAtti(eList, pkAtto, tipoAttoEnum, casoUso, getAttoParams())

        goToAllegatiANSCGrayed = isListServiziAllegatiEmpty()
    }

    Boolean isListServiziAllegatiEmpty() {
        if(casoUso == null){
            return true
        }
        return anscEndPointServizioArchivioService.listAllServiziAttoAllegatiByAndCasoUsoAndAtto(casoUso.id, atto).isEmpty()
    }

    protected Map getAttoParams(){
        return [fetch:[[campo:'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT], [campo:'motivoCittadinanza', tipo: JoinType.LEFT]]]
    }

    Map getCasoUsoParams(){
        CivCittadinanza cittadinanza = (CivCittadinanza)atto
        Map params = [categoria: cittadinanza.tipoAttoDomain?.categoriaDomain?.codice,
                      tipoAttoAnsc: cittadinanza.getTipoAttoAnsc(),
                      idMotivoCittadinanza:cittadinanza.motivoCittadinanza?.id]
        return params
    }

}
