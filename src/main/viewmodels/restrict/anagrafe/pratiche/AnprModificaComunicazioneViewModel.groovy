package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anpr.AnprComunicazione
import it.finmatica.de4gsdzk.anpr.AnprComunicazioneService
import it.finmatica.de4gsdzk.anpr.AnprDatiAggiuntiviComunicazione
import it.finmatica.de4gsdzk.anpr.AnprEndPointServizio
import it.finmatica.de4gsdzk.anpr.AnprEndPointServizioService
import it.finmatica.de4gsdzk.utils.EAnprTipoGestioneCF
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractPopupViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnprModificaComunicazioneViewModel extends AbstractPopupViewModel {

    AnprComunicazione dettaglio

    List<AnprEndPointServizio> listaServizi
    final List<EAnprTipoGestioneCF> listaTipiGestioneCF = EAnprTipoGestioneCF.values().toList()

    @WireVariable
    private AnprComunicazioneService anprComunicazioneService
    @WireVariable
    private AnprEndPointServizioService anprEndPointServizioService
    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("idOperazione") Long idOperazione) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("ANPR"), Etichette.getEtichetta("Chiudi"),
                           Etichette.getEtichetta("Salva"), Etichette.getEtichetta("Annulla_Scelta")]
        eList.addAll(AnprComunicazione.etichetteDomain)
        eList.addAll(AnprDatiAggiuntiviComunicazione.etichetteDomain)
        eList.addAll(EAnprTipoGestioneCF.values()*.getEtichettaDesc())


        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("ANPR"))

        dettaglio = anprComunicazioneService.findById(idOperazione)
        if(dettaglio.datiAggiuntivi == null) {
            dettaglio.datiAggiuntivi = new AnprDatiAggiuntiviComunicazione(id: idOperazione)
        }
        listaServizi = anprEndPointServizioService.findAllByFlagModificaPreIsTrue()

    }

    @Command
    void onAnnullaScelta() {
        dettaglio.datiAggiuntivi.gestioneCfAnpr = null
        refreshUi()
    }

    @Command
    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Command
    void onSalva() {
        anprComunicazioneService.salvaModificheComunicazione(dettaglio)
        onChiudi()
    }
}
