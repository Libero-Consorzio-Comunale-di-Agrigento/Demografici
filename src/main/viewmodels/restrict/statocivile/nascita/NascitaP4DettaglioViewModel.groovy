package restrict.statocivile.nascita

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.IstMp4
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
class NascitaP4DettaglioViewModel extends IstatDettaglioParentViewModel{

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = []
        eList.addAll(IstMp4.etichetteDomain)

        eList.addAll([Etichette.getEtichetta("SEZIONE_INTESTATARIO"), Etichette.getEtichetta("SEZIONE_NATO_A"),
                      Etichette.getEtichetta("SEZIONE_PADRE"), Etichette.getEtichetta("SEZIONE_MADRE"), Etichette.getEtichetta("SEZIONE_MODELLO_P4")])

        doInit(eList, tipoAttoEnum, ETipoModelloIstat.P4, Etichette.getEtichetta("SEZIONE_MODELLO_P4"))

        if (pkAtto){
            caricaAtto(tipoAttoEnum, pkAtto, [fetch:[[campo:'nazionalita', tipo: JoinType.LEFT]]])

            caricaDettaglio(null)

            caricaListaNazionalita()

            caricaListeArchivi("ISTMP4_V_DIZ", dettaglio.anno)

            caricaListeStatoCivile()
        } else {
            onChiudi()
        }
    }

    void caricaDettaglio(def id) {
        super.caricaDettaglio(id)

        if ( ( ((IstMp4)dettaglio).sezioneCensimento == null) && ((IstMp4)dettaglio).sezioneCensimentoDefault ){
            ((IstMp4)dettaglio).sezioneCensimento = new Integer(Integer.parseInt(dettaglio.sezioneCensimentoDefault))
        }
        refreshUi()
    }

}
