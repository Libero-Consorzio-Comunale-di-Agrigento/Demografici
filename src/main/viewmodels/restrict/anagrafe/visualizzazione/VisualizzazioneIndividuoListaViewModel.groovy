package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitControlBarCapable

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class VisualizzazioneIndividuoListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi, TraitControlBarCapable {

    final List<ESesso> listaSesso = [null] + ESesso.values().toList()
    final List<ETipoSiNo> listaSoloResidenti = ETipoSiNo.values() + null

    List<AnaAnagrafeBaseDomain> lista
    AnaAnagrafeBaseDomain dettaglio

    ETipoSorgenteRicercaIndividuo tipoSorgente
    RicercaIndividuo ricercaIndividuo

    @WireVariable
    GsdEtichettaService gsdEtichettaService

    @WireVariable
    AnaAnagrafeService anaAnagrafeService

    @WireVariable
    AnpAnagrafeService anpAnagrafeService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        controlBarAttributes.backEnabled = false
        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.Visualizzazione_Individuo]
        // Aggiungo etichette standard
        eList.addAll(etichetteListaDefault)
        // Aggiungo etichette domain
        eList.addAll(AnaAnagrafe.etichetteDomain)
        // Aggiungo etichette ricerca
        eList.addAll(RicercaIndividuo.etichetteRicercaDesc)
        // Aggiungo etichette per bottoni ricerca
        eList.addAll([Etichette.Ricerca_in_Anagrafe, Etichette.Ricerca_in_ANPR, Etichette.Ricerca_movimenti_rettificati])
        // Aggiungo etichette per valori campi di ricerca
        eList.addAll([Etichette.Cancella])
        eList.addAll(ESesso.values()*.getEtichettaDesc())

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.Visualizzazione_Individuo)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        resize()

        tipoSorgente = ETipoSorgenteRicercaIndividuo.ANA
        ricercaIndividuo = new RicercaIndividuo()
        ricercaIndividuo.ricercaRettificatiEnabled = true
        ricercaIndividuo.sessoEnabled = true
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(SortUtils.cognomeNomeNatoAsc))
        switch (tipoSorgente) {
            case ETipoSorgenteRicercaIndividuo.ANA:
                Page p = anaAnagrafeService.listAllByRicercaIndividuo(ricercaIndividuo, pr)
                return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
            case ETipoSorgenteRicercaIndividuo.MOV_RETT:
                List<AnaAnagrafe> l = anaAnagrafeService.listAllRettificatiByRicercaIndividuo(ricercaIndividuo)
                return new Paginazione(l, l.size())
            case ETipoSorgenteRicercaIndividuo.ANP:
                Page p = anpAnagrafeService.listByRicercaIndividuo(ricercaIndividuo, pr)
                return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
        }
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    void resetLista() {
        lista = []
        refreshLista()
    }

    @Command
    void onResetRicerca() {
        resetRicerca()
    }

    @Command
    void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricercaIndividuo, p)
        resetRicerca()
    }

    @Command
    void onSeleziona(){
        apriDettaglio("/restrict/anagrafe/visualizzazione/individuoDettaglio.zul", ["soggetto": dettaglio])
    }

    @Command
    void onRicerca() {
        tipoSorgente = ETipoSorgenteRicercaIndividuo.ANA
        onRicarica()
    }

    @Command
    void onRicercaRettificati() {
        tipoSorgente = ETipoSorgenteRicercaIndividuo.MOV_RETT
        onRicarica()
    }

    @Command
    void onRicercaANP() {
        tipoSorgente = ETipoSorgenteRicercaIndividuo.ANP
        onRicarica()
    }

}
