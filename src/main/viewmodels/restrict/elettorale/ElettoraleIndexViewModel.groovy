package restrict.elettorale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.elettorale.ElettoraleSezioneService
import it.finmatica.de4gsdzk.utils.*
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
class ElettoraleIndexViewModel extends AbstractIndexViewModel {

    @WireVariable
    ElettoraleSezioneService elettoraleSezioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("Dizionari"), Etichette.getEtichetta("Archivio")]
        //Aggiungo etichette menu laterale
        eList.addAll([Etichette.getEtichetta("Dati_Generali"), Etichette.getEtichetta("Configurazione"), Etichette.getEtichetta("Archivio_Elettori"), Etichette.getEtichetta("Web_Service_Ministero_Interno")])

        doInit(eList)

        selectedModulo = new Sezione(getEtichettaEnum(etichette, EModulo.ELETTORALE), EModulo.ELETTORALE.name(), "", EModulo.ELETTORALE.uri, EModulo.ELETTORALE.img)

        loadSezioni()
        selectedSezione = null
        selectedSubSezione = null

    }

    void loadSezioni() {
        sezioni = elettoraleSezioneService.listMenuPrincipale().collect { transform(it) }
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
            case Sezione.ARCHIVIO_ELETTORI:
                return "/restrict/elettorale/visualizzazione/archivioElettoriLista.zul"
            case Sezione.DIZIONARIO_DATI_GENERALI:
                return "/restrict/elettorale/dizionari/datiGenerali/datiGenerali.zul"
            case Sezione.DIZIONARIO_CONFIGURAZIONE:
                return "/restrict/elettorale/dizionari/configurazione/configurazione.zul"
            case Sezione.DIZIONARIO_WS_MININT:
                return "/restrict/elettorale/dizionari/wsMinisteriali/wsMinisteriali.zul"
        }

        return null
    }

}
