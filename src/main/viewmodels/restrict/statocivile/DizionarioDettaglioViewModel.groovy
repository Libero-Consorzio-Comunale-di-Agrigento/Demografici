package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import restrict.AbstractDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class DizionarioDettaglioViewModel extends AbstractDettaglioViewModel {

    // TODO: rimuovi in favore di ControlBarDettaglioAttributes di AbstractDettaglioViewModel
    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    void doInitEtichette(List<Map<String, String>> eList=[]) {
        eList.addAll(etichetteDettaglioDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)
    }

}
