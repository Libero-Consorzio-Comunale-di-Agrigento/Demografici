package restrict

import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ETipoComuneAtto
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.Event

trait TraitComune {

    abstract void selezionaComune(ETipoComuneAtto tc, ArcComuneBaseDomain c)

    abstract void refreshUi()

    @Command void onSelectComune(@ContextParam(ContextType.TRIGGER_EVENT) Event event, @BindingParam("campoRiferimento") String campoRiferimento){
        ArcComuneBaseDomain c = null
        if (event?.target?.selectedItem instanceof ArcComuneBaseDomain) {
            c = event.target.selectedItem
        }
        selezionaComune(ETipoComuneAtto.valueOf(campoRiferimento), c)
    }

    void riempiComune(Comune comuneTarget, ArcComuneBaseDomain comuneSource) {
        comuneTarget.codice = comuneSource?.codiceComune
        comuneTarget.descrizione = comuneSource?.descrizioneComune
        comuneTarget.codiceProvincia = comuneSource?.codiceProvincia
        comuneTarget.siglaProvincia = comuneSource?.siglaProvincia
        refreshUi()
    }

    @Command void onCancellaComune(@BindingParam("campoRiferimento") String campoRiferimento){
        onSelectComune(null, campoRiferimento)
    }

}