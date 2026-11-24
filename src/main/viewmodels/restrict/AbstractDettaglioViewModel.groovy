package restrict

import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zul.Messagebox

abstract class AbstractDettaglioViewModel extends AbstractCommonViewModel {

    abstract void caricaDettaglio(def id)
    abstract void creaDettaglio(Map params)
    abstract Object getDettaglio()

    boolean getCanDeleteRecord() {
        return dettaglio?.id != null
    }

    boolean getCanSaveRecord() {
        return true
    }

    protected void refreshDettaglio(){
        BindUtils.postNotifyChange(null, null, this, "dettaglio")
        BindUtils.postNotifyChange(null, null, this, "canDeleteRecord")
    }

    @Command
    void onBackFromRecord() {
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Modifiche_In_Sospeso")), getEtichetta(Etichette.getEtichetta("Chiusura")), Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
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
