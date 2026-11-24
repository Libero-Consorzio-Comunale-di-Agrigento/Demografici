package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.AnagrafeBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.anagrafe.AnaFamiglia
import it.finmatica.de4gsdzk.anagrafe.AnaFamigliaService
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoNonResidenteFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteEsteroFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitControlBarCapable


@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FamigliaListaViewModel extends AbstractListaViewModel implements TraitControlBarCapable, TraitIndividuoCorrente {

    AnaFamiglia famiglia

    List<AnaAnagrafe> lista
    AnaAnagrafe dettaglio
    boolean showAnp = false

    Date dataRiferimento

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    @WireVariable
    private AnaFamigliaService anaFamigliaService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("dataRiferimento") Date data) {
        self = w
        dataRiferimento = data

        controlBarAttributes.pagingEnabled = false
        controlBarAttributes.searchEnabled = false
        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Famiglia")]

        // Aggiungo etichette entità
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnaFamiglia.etichetteDomain)
        eList.addAll(IndirizzoResidenteFamiglia.etichetteDomain)
        eList.addAll(IndirizzoResidenteEsteroFamiglia.etichetteDomain)
        eList.addAll(IndirizzoNonResidenteFamiglia.etichetteDomain)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll([Etichette.getEtichetta("allegati_tooltip"), Etichette.getEtichetta("Storico_tooltip"), Etichette.getEtichetta("Storico_famiglia_tooltip")])

        eList.addAll([Etichette.getEtichetta("Warn_Nessun_elemento_selezionato")])

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Famiglia"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        resize()
        if(individuoCorrente.famiglia != null) {
            caricaFamiglia()
            caricaLista()
        }
    }

    private void caricaFamiglia() {
        this.famiglia = anaFamigliaService.findById(individuoCorrente.famiglia.id)
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        List<AnaAnagrafe> list = anaAnagrafeService.listAllByFamiglia(famiglia)

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

    @Command
    void onSeleziona() {
        openIndividuo(dettaglio)
    }

    private void openIndividuo(AnagrafeBaseDomain soggetto) {
        Events.postEvent(CustomEvents.ON_SELECT_RECORD, self, [soggetto: soggetto])
        onChiudi()
    }

    @Command
    void onOpenAllegati() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/famigliaAllegatiLista.zul", self.parent, [famiglia: famiglia])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form famiglia allegati", ex)
            throw ex
        }
    }

    @Command
    void onOpenStorico() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/famigliaStoricoLista.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                openIndividuo(event.data.soggetto as AnagrafeBaseDomain)
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form famiglia allegati", ex)
            throw ex
        }
    }

}
