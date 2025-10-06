package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractPopupViewModel extends AbstractCommonViewModel {

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    void doInitEtichette(List<Map<String, String>> eList = []) {
        eList.addAll(etichettePopupDefault)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)
    }

    static final List<Map<String, String>> etichettePopupDefault = [Etichette.Salva, Etichette.Conferma, Etichette.Chiudi]

}
