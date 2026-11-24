package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazione
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazioneService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaCondizioneComunicazione
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaCondizioneComunicazioneService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioneCondizioneListaViewModel extends DizionarioListaViewModel{

    Component opener
    AnaComunicazione comunicazione

    List<AnaCondizioneComunicazione> lista = []
    AnaCondizioneComunicazione dettaglio


    @WireVariable
    private AnaComunicazioneService anaComunicazioneService

    @WireVariable
    private AnaCondizioneComunicazioneService anaCondizioneComunicazioneService

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("comunicazione") AnaComunicazione comunicazione,
               @ExecutionArgParam("opener") Component opener) {
        self = w

        pagingEnabled = false
        deleteEnabled = true
        modifyEnabled = false

        List<Map<String, String>> eList = [Etichette.getEtichetta("Comunicazione")]

        eList.addAll(AnaCondizioneComunicazione.etichetteDomain)
        
        
        doInitEtichette(eList)

        // Devo ricaricare la comunicazione perché l'include prende in maniera statica i parametri
        this.comunicazione = anaComunicazioneService.get(comunicazione.id)
        this.opener = opener

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazione"))

        totalSizeLabel = ""

        caricaLista()

    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    void resetDettaglio() {
        dettaglio = null
        caricaLista()
        BindUtils.postNotifyChange(null, null, this, "dettaglio")
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        log.info ("usePaging: " + usePaging)
        List<AnaCondizioneComunicazione> l = anaCondizioneComunicazioneService.findAllByComunicazione(comunicazione)


        return new Paginazione(l, l.size())
    }
    
    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/comunicazioni/comunicazioneCondizioneDettaglio.zul"
    }

    @Command
    void onInserisci() {
        if (comunicazione?.id) {
            apriDettaglio("/restrict/anagrafe/dizionari/comunicazioni/comunicazioneCondizioneDettaglio.zul", opener, [comunicazione: comunicazione])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvare_prima_la_comunicazione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command
    void onElimina() {
        if (dettaglio) {
            Messagebox.show(
                    getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")),
                    msgTitle,
                    Messagebox.OK | Messagebox.CANCEL,
                    Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK == e.getName()) {
                                anaCondizioneComunicazioneService.delete(dettaglio)
                                dettaglio = null
                                caricaLista()
                            }
                        }
                    }
            )
        }
    }

}
