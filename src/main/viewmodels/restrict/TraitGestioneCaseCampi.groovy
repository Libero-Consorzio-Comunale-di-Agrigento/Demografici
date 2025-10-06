package restrict

import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.Event

trait TraitGestioneCaseCampi<D> extends TraitDettaglio<D> {

    abstract Map getMinuscole()

    @Command void onAggiornaCase(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        aggiornaCase(dettaglio, p)
    }

    void aggiornaCase(Object entita, String p) {
        if (p) {
            Boolean upper = (!(minuscole[p]))
            if (upper) {
                entita."$p" = entita."$p"?.toUpperCase()
            }
            refreshUi()
        }
    }

}