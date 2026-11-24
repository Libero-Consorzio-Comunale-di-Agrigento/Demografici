package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.AnaFamigliaStorico
import it.finmatica.de4gsdzk.anagrafe.AnaFamigliaStoricoService
import it.finmatica.de4gsdzk.anagrafe.RicercaFamiglia
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.anagrafe.AbstractFamigliaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class VisualizzazioneFamigliaListaViewModel extends AbstractFamigliaViewModel {

    List<AnaFamigliaStorico> lista
    AnaFamigliaStorico dettaglio

    RicercaFamiglia ricercaFamiglia

    @WireVariable
    GsdEtichettaService gsdEtichettaService

    @WireVariable
    AnaFamigliaStoricoService anaFamigliaStoricoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        controlBarAttributes.backEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Visualizzazione_Famiglia")]

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        doInitVMFamglia(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Visualizzazione_Famiglia"))
        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        resize()

        ricercaFamiglia = new RicercaFamiglia()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE))
        Page p = anaFamigliaStoricoService.listAllByRicercaFamiglia(ricercaFamiglia, pr)
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
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
        cancellaCampo(ricercaFamiglia, p)
        resetRicerca()
    }

    @Command
    void onSeleziona() {
        if(dettaglio?.capoFamiglia){
            apriDettaglio("/restrict/anagrafe/visualizzazione/individuoDettaglio.zul", ["soggetto": dettaglio.capoFamiglia])
        }
    }

    @Command
    void onRicerca() {
        onRicarica()
    }

    @Override
    void selezionaVia(ArcVia c) {
        ricercaFamiglia.via = c
    }
}
