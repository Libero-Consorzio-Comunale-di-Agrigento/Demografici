package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.ETipoSiNo
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
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitControlBarCapable
import restrict.TraitVia

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class VisualizzazioneFamigliaListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi, TraitControlBarCapable, TraitVia {
    final List<ETipoFamiglia> listaTipoFamiglia = [null] + Arrays.asList(ETipoFamiglia.values())
    final List<ETipoSiNo> listaIscrittoInAPR = [null] + Arrays.asList(ETipoSiNo.values())

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
        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.Visualizzazione_Famiglia]
        // Aggiungo etichette standard
        eList.addAll(etichetteListaDefault)
        // Aggiungo etichette header
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnaFamiglia.etichetteDomain)
        eList.addAll([Etichette.Iscritto_in_APR])
        // Aggiungo etichette ricerca
        eList.addAll(RicercaFamiglia.etichetteRicercaDesc)
        eList.addAll(ETipoFamiglia.values()*.etichettaDesc)
        eList.addAll(ETipoSiNo.values()*.etichettaDesc)
        eList.add(Etichette.Tutti)
        // Aggiungo etichette per bottoni ricerca
        eList.addAll([Etichette.Ricerca_in_Anagrafe])
        // Aggiungo etichette per valori campi di ricerca
        eList.addAll([Etichette.Cancella])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.Visualizzazione_Famiglia)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        resize()

        ricercaFamiglia = new RicercaFamiglia()
        ricercaFamiglia.data = DataUtils.getDataCorrente()
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
