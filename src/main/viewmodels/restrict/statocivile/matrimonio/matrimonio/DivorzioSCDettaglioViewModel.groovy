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
class DivorzioSCDettaglioViewModel extends IstatDettaglioParentViewModel{

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.SEZIONE_MODELLO_SC, Etichette.SEZIONE_DATI_ATTO, Etichette.SEZIONE_DATI_MATRIMONIO,
                           Etichette.SEZIONE_MARITO, Etichette.SEZIONE_MOGLIE, Etichette.SEZIONE_AVVOCATI, Etichette.SEZIONE_FIGLI]
        eList.addAll(IstMscDivorzio.etichetteDomain)

        doInit(eList, tipoAttoEnum, ETipoModelloIstat.SC, Etichette.SEZIONE_MODELLO_SC)

        if (pkAtto){
            caricaAtto(tipoAttoEnum, pkAtto, [fetch:[[campo:'nazionalita1', tipo: JoinType.LEFT], [campo:'nazionalita2', tipo: JoinType.LEFT]]])

            caricaDettaglio(null)

            formLabel+= " " + ((IstMscDivorzio)dettaglio).codiceModelloIstat

            caricaListeArchivi("ISTMSC_V_DIZ", dettaglio.anno)

            caricaListeStatoCivile()
        } else {
            onChiudi()
        }
    }

}
