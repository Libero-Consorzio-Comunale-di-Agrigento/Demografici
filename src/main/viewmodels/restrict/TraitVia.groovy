package restrict

import it.finmatica.de4gsdzk.archivi.ArcVia
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.Event

trait TraitVia {

    abstract void selezionaVia(ArcVia c)

    abstract void refreshUi()

    @Command
    void onSelectVia(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        ArcVia c = null
        if (event?.target?.selectedItem instanceof ArcVia) {
            c = event.target.selectedItem
        }
        selezionaVia(c)
        refreshUi()
    }

}