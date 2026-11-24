package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.utils.*
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

        List<Map<String, String>> eList = [Etichette.getEtichetta("Tipi_di_Verbale"), Etichette.getEtichetta("Funzione_non_abilitata")]
        // Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_tipo_atto")])

        eList.addAll(CivTipoAtto.etichetteDomain)

        // Aggiungo etichette natura atto
        eList += ENaturaAtto.values()*.getEtichettaDesc() as Map

        // Aggiungo etichette tipo atto
        eList.addAll(listaTipiAtto*.etichettaPluralDesc)
        eList.addAll(listaTipiAtto*.etichettaDesc)

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Sequenza_crescente"), Etichette.getEtichetta("Sequenza_decrescente")])

        doInitEtichette(eList)

        totalSizeLabel = ""

        msgTitle = getEtichetta(Etichette.getEtichetta("Tipi_di_Verbale"))

        formLabel = msgTitle?.toUpperCase()

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Sequenza_crescente")), SortUtils.sequenzaAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Sequenza_decrescente")), SortUtils.sequenzaDesc)])

        selectedOrder = listaOrder[0]
    }

    @Command void onSelectTipoAtto() {
        onRicarica()
    }

    @Override
    Map getAdditionalFilters() {
        return [:]
    }
}
