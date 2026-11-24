package restrict.levamilitare

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.levamilitare.LevaMilitareSezioneService
import it.finmatica.de4gsdzk.utils.EModulo
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Sezione
import it.finmatica.de4gsdzk.utils.SezioneBusiness
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractIndexViewModel

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta
import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichettaEnum

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class LevaMilitareIndexViewModel extends AbstractIndexViewModel {

    @WireVariable
    LevaMilitareSezioneService levaMilitareSezioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("Dizionari")]
        //Aggiungo etichette menu laterale
        eList.addAll([Etichette.getEtichetta("Configurazione")])

        doInit(eList)

        selectedModulo = new Sezione(getEtichettaEnum(etichette, EModulo.LEVA_MILITARE), EModulo.LEVA_MILITARE.name(), "", EModulo.LEVA_MILITARE.uri, EModulo.LEVA_MILITARE.img)

        loadSezioni()
        selectedSezione = null
        selectedSubSezione = null

    }

    void loadSezioni() {
        sezioni = levaMilitareSezioneService.listMenuPrincipale().collect { transform(it) }
    }

    private Sezione transform(SezioneBusiness sezioneBusiness) {

        if (sezioneBusiness.subSezioni.isEmpty()) {
            return new Sezione(getEtichetta(etichette, sezioneBusiness.etichetta), sezioneBusiness.id, "", getUri(sezioneBusiness))
        }

        List<Sezione> subSezioni = []

        for (SezioneBusiness child : sezioneBusiness.subSezioni) {
            Sezione transformedChild = transform(child)
            subSezioni.add(transformedChild)
        }

        return new Sezione(getEtichetta(etichette, sezioneBusiness.etichetta), sezioneBusiness.id, "", "", "", subSezioni)
    }

    String getUri(SezioneBusiness sezione) {
        switch (sezione.id) {
            case Sezione.DIZIONARIO_CONFIGURAZIONE:
                return "/restrict/levamilitare/dizionari/configurazione/configurazione.zul"
        }

        return null
    }

}
