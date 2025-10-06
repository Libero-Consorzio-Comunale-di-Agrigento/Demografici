package it.finmatica.de4gsdzk.certificazione.emissione

import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.certificazione.embed.Richiedente

class RichiedenteViewState {
    Richiedente richiedente
    GsdAnagrafeBaseDomain anagrafe
    boolean documentoMandatory = false
    boolean datiAnagraficiMandatory = false

    RichiedenteViewState() {
        richiedente = new Richiedente()
    }

    void reset() {
        richiedente = new Richiedente()
        anagrafe = null
        documentoMandatory = false
        datiAnagraficiMandatory = false
    }
}
