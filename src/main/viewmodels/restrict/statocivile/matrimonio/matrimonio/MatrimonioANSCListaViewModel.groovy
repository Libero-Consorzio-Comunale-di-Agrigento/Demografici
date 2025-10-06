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
class MatrimonioANSCListaViewModel extends AnscAttoListaParentViewModel {

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
                      tipoAttoAnsc: matrimonio.getTipoAttoAnsc(),
                      riconoscimentoFigli: matrimonio.riconoscimentoFigli]
        params.put("categoria", matrimonio.tipoAttoDomain?.categoriaDomain?.codice)
        params.put("flagRitoCattolico", datiProvenienza.flagRitoCattolico)
        params.put("flagCasaComunale", datiProvenienza.flagCasaComunale)
        if (datiProvenienza.flagExArt19){
            params.put("flagExArt19", datiProvenienza.flagExArt19)
        }
        if (datiProvenienza.flagStranieriNonResidenti) {
            params.put("flagStranieriNonResidenti", datiProvenienza.flagStranieriNonResidenti)
        }
        return params
    }

    /*
    refs #71063
    Gestione spostata nel parent per implementazione attestazione di conformità
    String getTipoDocumentoCdu(){
        CivMatrimonio matrimonio = (CivMatrimonio)atto
        if (matrimonio.isTrascrizioneEsteroDaPrivato()){
            return datiProvenienza?.tipoRichiestaTrascrizione?.name()
        }
        return null
    }

    protected String getTipoEventoCdu(){
        CivMatrimonio matrimonio = (CivMatrimonio)atto
        if (matrimonio.isTrascrizioneEsteroDaPrivato()){
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


