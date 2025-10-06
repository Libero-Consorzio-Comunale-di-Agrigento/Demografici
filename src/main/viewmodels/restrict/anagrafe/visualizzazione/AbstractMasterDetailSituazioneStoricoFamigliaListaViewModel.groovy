package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaEventoAnagrafeFamiglia
import it.finmatica.de4gsdzk.anagrafe.AnaEventoAnagrafeFamigliaService
import it.finmatica.de4gsdzk.anagrafe.AnaFamiglia
import it.finmatica.de4gsdzk.utils.CustomEvents
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import restrict.AbstractListaViewModel

/***
 * Classe che gestisce la visualizzazione delle pagine (di tipo master/detail) che mostrano la situazione di una famiglia ad una certa data
 */
@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractMasterDetailSituazioneStoricoFamigliaListaViewModel extends AbstractListaViewModel {

    List<AnaEventoAnagrafeFamiglia> eventoAnagrafeFamigliaList

    @WireVariable
    private AnaEventoAnagrafeFamigliaService anaEventoAnagrafeFamigliaService

    @Command
    void onBack() {
        Events.postEvent(CustomEvents.ON_BACK_FROM_LIST, self, [:])
        onChiudi()
    }

    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Command
    abstract void onSelectDettaglio()

    void caricaListaEventoAnagrafeFamiglia(AnaFamiglia famiglia, Date dataEvento) {
        if(dataEvento && famiglia) {
            eventoAnagrafeFamigliaList = anaEventoAnagrafeFamigliaService.findAllByFamigliaAndDataEvento(famiglia, dataEvento)
            refreshUi()
        }
    }

    @Command
    void onSelezionaEventoAnagrafeFamiglia(@BindingParam("evento") AnaEventoAnagrafeFamiglia evento) {
        Events.postEvent(CustomEvents.ON_SELECT_RECORD, self, [soggetto: evento.anagrafe])
        onChiudi()
    }

}
