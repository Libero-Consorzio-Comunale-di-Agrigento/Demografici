package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnscServiziDettaglioViewModel extends DizionarioDettaglioViewModel{

    AnscEndPointServizio dettaglio

    @WireVariable
    private AnscEndPointServizioService anscEndPointServizioService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id){
        self = w

        backFromRecordEnabled = true
        saveRecordEnabled = true
        deleteRecordEnabled = true

        List<Map<String, String>> eList = [EtichetteMessaggi.Ask_Cancellazione_Record, Etichette.Servizi_Ansc]

        eList.addAll(AnscEndPointServizio.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Servizi_Ansc)

        formLabel = msgTitle?.toUpperCase()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }

    }

    void caricaDettaglio(def id) {
        if (id != null){
            dettaglio = anscEndPointServizioService.get(id)
        }
        refreshUi()
    }

    @Command void onSalvaRecord(){
        if (dettaglio){
            AnscEndPointServizio c = anscEndPointServizioService.save(dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnscEndPointServizio(params)
    }

    @Command void onEliminaRecord(){
        if (dettaglio) {
            Messagebox.show(dettaglio.descrizioneEstesa + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                eliminaServizio(dettaglio)
                            }
                        }
                    }
            )
        }
    }

    void eliminaServizio(AnscEndPointServizio obj){
        anscEndPointServizioService.delete(obj)
        onChiudi()
    }

}
