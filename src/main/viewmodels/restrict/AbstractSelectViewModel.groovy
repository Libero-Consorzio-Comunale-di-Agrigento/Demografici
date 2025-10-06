package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractSelectViewModel extends AbstractListaViewModel{

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    void doInitEtichette(List<Map<String, String>> eList=[]) {
        eList.addAll([Etichette.Seleziona, Etichette.seleziona_tooltip, Etichette.seleziona_salva_tooltip, Etichette.Chiudi])

        eList.addAll(etichetteListaDefault)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)
    }

    @Command void onChiudi () {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

}
