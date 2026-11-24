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
class UnioneCivileANSCListaViewModel extends AnscAttoListaParentViewModel {

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
                      tipoAttoAnsc: uci.getTipoAttoAnsc()]
        params.put("flagCasaComunale", datiProvenienza.flagCasaComunale)
        if (datiProvenienza.flagExArt19){
            params.put("flagExArt19", datiProvenienza.flagExArt19)
        }
        return params
    }

    /*
    refs #71063
    Gestione spostata nel parent per implementazione attestazione di conformità
    String getTipoDocumentoCdu(){
        CivUnioneCivile uci = (CivUnioneCivile)atto
        if (uci.isTrascrizioneEsteroDaPrivato()){
            return datiProvenienza?.tipoRichiestaTrascrizione?.name()
        }
        return null
    }

    protected String getTipoEventoCdu(){
        CivUnioneCivile uci = (CivUnioneCivile)atto
        if (uci.isTrascrizioneEsteroDaPrivato()){
            if (datiProvenienza?.tipoRichiestaTrascrizione == ETipoRichiestaTrascrizione.CV){
                return ETipoRichiestaTrascrizione.CV.name()
            } else {
                return super.getTipoEventoCdu()
            }
        }
        return super.getTipoEventoCdu()
    }
    */

}


