package restrict.anagrafe.visualizzazione

import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import org.zkoss.zk.ui.Sessions

trait TraitIndividuoCorrente {
    void setIndividuoCorrente(AnaAnagrafe individuo) {
        Sessions.getCurrent().setAttribute("individuoCorrente", individuo)
    }

    AnaAnagrafe getIndividuoCorrente() {
        return Sessions.getCurrent().getAttribute("individuoCorrente") as AnaAnagrafe
    }

    void setAnprIndividuoCorrente(AnpAnagrafe individuo) {
        Sessions.getCurrent().setAttribute("anprIndividuoCorrente", individuo)
    }

    AnpAnagrafe getAnprIndividuoCorrente() {
        return Sessions.getCurrent().getAttribute("anprIndividuoCorrente") as AnpAnagrafe
    }
}