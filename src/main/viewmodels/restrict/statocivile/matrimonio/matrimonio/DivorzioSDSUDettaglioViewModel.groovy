package restrict.statocivile.matrimonio.matrimonio

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.IstMscDivorzio
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
class DivorzioSDSUDettaglioViewModel extends IstatDettaglioParentViewModel{

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("SEZIONE_MODELLO_SDSU"), Etichette.getEtichetta("SEZIONE_DATI_ATTO"),
                           Etichette.getEtichetta("SEZIONE_DATI_MATRIMONIO"), Etichette.getEtichetta("SEZIONE_MARITO"), Etichette.getEtichetta("SEZIONE_MOGLIE")]

        eList.addAll(IstMscDivorzio.etichetteDomain)

        doInit(eList, tipoAttoEnum, ETipoModelloIstat.SDSU, Etichette.getEtichetta("SEZIONE_MODELLO_SDSU"))

        if (pkAtto){
            caricaAtto(tipoAttoEnum, pkAtto, [fetch:[[campo:'nazionalita1', tipo: JoinType.LEFT], [campo:'nazionalita2', tipo: JoinType.LEFT]]])

            caricaDettaglio(null)

            caricaListeArchivi("ISTMSDSU_V_DIZ", dettaglio.anno)

            caricaListeStatoCivile()
        } else {
            onChiudi()
        }
    }

}
