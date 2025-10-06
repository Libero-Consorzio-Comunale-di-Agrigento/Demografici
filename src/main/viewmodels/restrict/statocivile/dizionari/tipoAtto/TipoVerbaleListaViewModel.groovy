package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.utils.ENaturaAtto
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class TipoVerbaleListaViewModel extends TipoAttoListaParentViewModel{

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        searchEnabled = true
        addEnabled = false
        deleteEnabled = false

        listaTipiAtto = [ETipoAtto.PUB, ETipoAtto.PVU]

        List<Map<String, String>> eList = [Etichette.Tipi_di_Verbale, Etichette.Funzione_non_abilitata]
        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_tipo_atto])

        eList.addAll(CivTipoAtto.etichetteDomain)

        // Aggiungo etichette natura atto
        eList += ENaturaAtto.values()*.getEtichettaDesc() as Map

        // Aggiungo etichette tipo atto
        eList.addAll(listaTipiAtto*.etichettaPluralDesc)
        eList.addAll(listaTipiAtto*.etichettaDesc)

        doInitEtichette(eList)

        totalSizeLabel = ""

        msgTitle = getEtichetta(Etichette.Tipi_di_Verbale)

        formLabel = msgTitle?.toUpperCase()
    }

    @Command void onSelectTipoAtto() {
        onRicarica()
    }

    @Override
    Map getAdditionalFilters() {
        return [:]
    }
}
