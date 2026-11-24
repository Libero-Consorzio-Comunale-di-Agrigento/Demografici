package restrict.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnagrafeSezioneService
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
class AnagrafeIndexViewModel extends AbstractIndexViewModel {

    @WireVariable
    AnagrafeSezioneService anagrafeSezioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("Dizionari"), Etichette.getEtichetta("Visualizzazione"), Etichette.getEtichetta("Pratiche")]
        //Aggiungo etichette menu laterale
        eList.addAll([Etichette.getEtichetta("Visualizzazione_Individuo"), Etichette.getEtichetta("Visualizzazione_Famiglia"), Etichette.getEtichetta("Dati_Generali"), Etichette.getEtichetta("Configurazione"), Etichette.getEtichetta("Gestione_Pratiche"),
                      Etichette.getEtichetta("ANPR"), Etichette.getEtichetta("Documenti"), Etichette.getEtichetta("Comunicazioni"), Etichette.getEtichetta("Provvedimenti")])

        doInit(eList)

        selectedModulo = new Sezione(getEtichettaEnum(etichette, EModulo.ANAGRAFE), EModulo.ANAGRAFE.name(), "", EModulo.ANAGRAFE.uri, EModulo.ANAGRAFE.img)

        loadSezioni()
        selectedSezione = null
        selectedSubSezione = null

        if (requestForwardingParams.get('operation') == 'OPEN_VISUALIZZAZIONE') {
            List<Sezione> list = sezioni + sezioni*.subSezioni.flatten() as List<Sezione>
            Sezione visualizzazioneIndividuo = list.find { it.value == Sezione.VISUALIZZAZIONE }
            onSelectSezione(visualizzazioneIndividuo)
        }
    }

    void loadSezioni() {
        sezioni = anagrafeSezioneService.listMenuPrincipale().collect { transform(it) }
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
            case Sezione.VISUALIZZAZIONE_INDIVIDUO:
                return "/restrict/anagrafe/visualizzazione/visualizzazioneIndividuoLista.zul"
            case Sezione.VISUALIZZAZIONE_FAMIGLIA:
                return "/restrict/anagrafe/visualizzazione/visualizzazioneFamigliaLista.zul"
            case Sezione.DIZIONARIO_DATI_GENERALI:
                return "/restrict/anagrafe/dizionari/generale/datoGenerale.zul"
            case Sezione.DIZIONARIO_CONFIGURAZIONE:
                return "/restrict/anagrafe/dizionari/configurazione/configurazione.zul"
            case Sezione.DIZIONARIO_ANPR:
                return "/restrict/anagrafe/dizionari/anpr/anpr.zul"
            case Sezione.GESTIONE_PRATICHE:
                return "/restrict/anagrafe/pratiche/praticaLista.zul"
            case Sezione.DIZIONARIO_DOCUMENTI:
                return "/restrict/anagrafe/dizionari/documenti/documenti.zul"
            case Sezione.DIZIONARIO_COMUNICAZIONI:
                return "/restrict/anagrafe/dizionari/comunicazioni/comunicazioni.zul"
            case Sezione.DIZIONARIO_PROVVEDIMENTI:
                return "/restrict/anagrafe/dizionari/provvedimenti/provvedimenti.zul"
        }

        return null
    }

}
