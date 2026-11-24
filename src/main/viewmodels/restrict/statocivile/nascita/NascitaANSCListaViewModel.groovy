package restrict.statocivile.nascita

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivNascita
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
class NascitaANSCListaViewModel extends AnscAttoListaParentViewModel {

    @Delegate
    ControlBarANSCAttributes cbANSC = new ControlBarANSCAttributes()

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("pkAtto") Long pkAtto,
         @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
         @ExecutionArgParam("casoUso") AnscCasoUsoBaseDomain casoUso) {
        self = w

        backFromListANSCEnabled = true

        List<Map> eList = [Etichette.getEtichetta("SEZIONE_NATO_A"), Etichette.getEtichetta("SEZIONE_MADRE"), Etichette.getEtichetta("SEZIONE_PADRE")]

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
        CivNascita nascita = (CivNascita)atto
        Map params = [parte: nascita.parte,
                      serie: nascita.serie,
                      categoria: nascita.tipoAttoDomain?.categoriaDomain?.codice,
                      tipoAttoAnsc: nascita.getTipoAttoAnsc(),
                      tipoFiliazione: nascita.tipoFiliazione,
                      natoMorto: nascita.natoMorto,
                      tipoConsenso: nascita.tipoConsenso,
                      tipoRiconoscimento: nascita.tipoRiconoscimento]
        params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
        params.put("tipoComparente", datiProvenienza.tipoComparente)
        params.put("attoNotarile", datiProvenienza.attoNotarile)
        params.put("dichiarazioneGiudiziale", datiProvenienza.dichiarazioneGiudiziale)
        params.put("comparenteInterprete", datiProvenienza.isComparenteInterprete())
        params.put("comparenteProcuratore", datiProvenienza.isComparenteProcuratore())
        params.put("fasciaEtaFiglio", null) // da gestire nei ric post-nascita
        if (datiProvenienza.flagExArt19){
            params.put("flagExArt19", datiProvenienza.flagExArt19)
        }
        return params
    }

    /*
    refs #71063
    Gestione spostata nel parent per implementazione attestazione di conformità
    String getTipoDocumentoCdu(){
        CivNascita nascita = (CivNascita)atto
        if (nascita.isTrascrizioneEsteroDaPrivato()){
            return datiProvenienza?.tipoRichiestaTrascrizione?.name()
        }
        return datiProvenienza?.tipoAccertamento?.name()
    }

    protected String getTipoEventoCdu(){
        CivNascita nascita = (CivNascita)atto
        if (nascita.isTrascrizioneEsteroDaPrivato()){
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

