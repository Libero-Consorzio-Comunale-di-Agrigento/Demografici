package restrict

import it.finmatica.de4gsdzk.utils.CancellaCampoUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.Event

trait TraitCancellazioneCampi<D> extends TraitDettaglio<D> {

    @Command void onCancellaCampo(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(dettaglio, p)
    }

    void cancellaCampo(Object entita, String campo) {
        if (campo) {
            CancellaCampoUtils.cancellaCampo(entita, campo)
            refreshUi()
        }
    }

}