package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnpAnagrafeService
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.Paginazione
import org.springframework.data.domain.PageRequest
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FamigliaAnprListaViewModel extends AbstractListaViewModel implements TraitIndividuoCorrente {

    List<AnpAnagrafe> lista
    AnpAnagrafe dettaglio
    boolean showAnp = true

    @WireVariable
    private AnpAnagrafeService anpAnagrafeService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = []

        // Aggiungo etichette entità
        eList.addAll(AnpAnagrafe.etichetteDomain)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        eList.addAll([EtichetteMessaggi.Warn_Nessun_elemento_selezionato])

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = ""

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        resize()

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest(0, Integer.MAX_VALUE)
        List<AnpAnagrafe> list = anpAnagrafeService.listByFamigliaDiAnpAnagrafe(anprIndividuoCorrente, pr).content

        return new Paginazione(list, list.size())
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
    void onBack() {
        Events.postEvent(CustomEvents.ON_BACK_FROM_LIST, self, [:])
        onChiudi()
    }

    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    /*@Command
    void onSeleziona() {
        Window window = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/individuoDettaglio.zul", null, ["soggetto": dettaglio])
        window.doModal()
    }*/


}
