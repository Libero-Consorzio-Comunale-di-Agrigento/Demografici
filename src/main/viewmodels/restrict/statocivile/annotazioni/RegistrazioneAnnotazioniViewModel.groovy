package restrict.statocivile.annotazioni

import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractTabNavigatorViewModel

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

@VariableResolver(DelegatingVariableResolver.class)
class RegistrazioneAnnotazioniViewModel extends AbstractTabNavigatorViewModel {

    String comuneClienteLabel = ""

    @WireVariable
    private ArcComuneBaseService arcComuneBaseService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map> eList = [Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Altro_comune")]

        doInit(w, eList)

        ArcComune comune = arcComuneBaseService.getComuneCliente()
        comuneClienteLabel = getEtichetta(etichette, Etichette.getEtichetta("Comune")) + " " + comune.descrizioneComune

        resize()
    }

}