package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.AnagrafeBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaConvivenzaDiFatto
import it.finmatica.de4gsdzk.anagrafe.AnaConvivenzaDiFattoService
import it.finmatica.de4gsdzk.anagrafe.AnaDocumentoService
import it.finmatica.de4gsdzk.anagrafe.EStatoConvivenza
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
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
import restrict.TraitControlBarCapable
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ConvivenzaDiFattoDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitControlBarCapable, TraitIndividuoCorrente {

    AnaConvivenzaDiFatto dettaglio

    boolean documentiButtonEnabled = true

    @WireVariable
    private AnaConvivenzaDiFattoService anaConvivenzaDiFattoService

    @WireVariable
    private AnaDocumentoService anaDocumentoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        controlBarAttributes.pagingEnabled = false
        controlBarAttributes.searchEnabled = false
        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        List<Map<String, String>> eList = [Etichette.getEtichetta("Convivenza_di_fatto")]
        // Aggiungo etichette controlbar
        eList.addAll([Etichette.getEtichetta("Documenti_tooltip")])
        // Aggiungo etichette per sezioni
        eList.addAll([Etichette.getEtichetta("Convivenza_di_fatto")])
        // Aggiungo etichette entità
        eList.addAll(AnaConvivenzaDiFatto.etichetteDomain)
        eList.addAll(EStatoConvivenza.values()*.etichettaDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Convivenza_di_fatto"))
        formLabel = msgTitle?.toUpperCase()

        resize()

        caricaDettaglio(individuoCorrente.convivenzaDiFatto.id)

        documentiButtonEnabled = anaDocumentoService.existsConvivenzaDiFattoByAnagrafe(individuoCorrente)
    }

    void caricaDettaglio(def id) {
        dettaglio = anaConvivenzaDiFattoService.get(id)

        refreshUi()
    }

    void creaDettaglio(Map params) {
        throw new IllegalStateException("Non implementato")
    }

    @Command
    void onBack() {
        Events.postEvent(CustomEvents.ON_BACK_FROM_RECORD, self, [:])
        onChiudi()
    }

    @Command
    void onOpenConvivente() {
        openIndividuo(dettaglio.convivente)
    }

    private void openIndividuo(AnagrafeBaseDomain soggetto) {
        Events.postEvent(CustomEvents.ON_SELECT_RECORD, self, [soggetto: soggetto])
        onChiudi()
    }

    @Command
    void onOpenDocumenti() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/documentoConvivenzaDiFattoLista.zul", self.parent, [individuo: dettaglio])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form documenti convivenza di fatto", ex)
            throw ex
        }
    }
}
