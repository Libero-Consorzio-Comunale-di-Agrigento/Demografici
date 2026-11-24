package restrict.statocivile.morte

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.IstMd4
import it.finmatica.de4gsdzk.utils.ArchivioIstat
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoModelloIstat
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.statocivile.IstatDettaglioParentViewModel

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MorteD4DettaglioViewModel extends IstatDettaglioParentViewModel{

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("SEZIONE_MODELLO_D4"), Etichette.getEtichetta("SEZIONE_DATI_DECESSO"), Etichette.getEtichetta("SEZIONE_DECEDUTO")]
        eList.addAll(IstMd4.etichetteDomain)

        doInit(eList, tipoAttoEnum, ETipoModelloIstat.D4, Etichette.getEtichetta("SEZIONE_MODELLO_D4"))

        if (pkAtto){
            caricaAtto(tipoAttoEnum, pkAtto, [fetch:[[campo:'nazionalita', tipo: JoinType.LEFT]]])

            caricaDettaglio(null)

            caricaListeArchivi("ISTMD4_V_DIZ", dettaglio.anno)

            caricaListeStatoCivile()

            caricaListaNazionalita()
        } else {
            onChiudi()
        }
    }

    String getDescrizioneStatoCivile(String codice){
        for (ArchivioIstat m:listaStatoCivile1){
            if (m?.codiceAds == codice){
                return m.descrizione
            }
        }
        return ""
    }

}
