package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractTabNavigatorViewModel extends AbstractResizedViewModel{

    Window self

    Map<String, String> etichette = [:]

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    void doInit(Window w, List<Map<String, String>> eList=[]) {
        self = w

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)
    }

        String getEtichettaEnum(Enum e, String etichettaDefault=null) {
        return e ? getEtichetta(e.getEtichettaDesc()) : getEtichetta(etichettaDefault)
    }

    String getEtichettaPluralEnum(Enum e, String etichettaDefault=null) {
        return e ? getEtichetta(e.getEtichettaPluralDesc()) : getEtichetta(etichettaDefault)
    }

    String getEtichetta(Map<String, String> etichetta) {
        return etichetta ? getEtichetta((String) etichetta.codice) : ""
    }

    String getEtichetta(String codice) {
        return codice ? etichette[codice] : ""
    }

    String getEtichettaCustom(String codice) {
        return codice ? etichetteCustom[codice] : ""
    }

}
