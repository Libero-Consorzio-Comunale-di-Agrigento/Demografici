package restrict

import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zul.Messagebox

abstract class AbstractDettaglioViewModel extends AbstractCommonViewModel {

    abstract void caricaDettaglio(def id)
    abstract void creaDettaglio(Map params)

    protected void refreshDettaglio(){
        BindUtils.postNotifyChange(null, null, this, "dettaglio")
    }

    @Command
    void onBackFromRecord() {
        Messagebox.show(getEtichetta(EtichetteMessaggi.Ask_Modifiche_In_Sospeso), getEtichetta(Etichette.Chiusura), Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_YES.equals(e.getName())) {
                            Events.postEvent(CustomEvents.ON_BACK_FROM_RECORD, self, [:])
                            onChiudi()
                        }
                    }
                }
        )
    }

}
