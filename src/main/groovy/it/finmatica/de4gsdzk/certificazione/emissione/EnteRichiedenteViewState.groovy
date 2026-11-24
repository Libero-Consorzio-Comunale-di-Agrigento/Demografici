package it.finmatica.de4gsdzk.certificazione.emissione

import it.finmatica.de4gsdzk.certificazione.embed.EnteRichiedente

class EnteRichiedenteViewState {
    EnteRichiedente enteRichiedente
    Boolean comuneEstero = Boolean.FALSE

    EnteRichiedenteViewState() {
        enteRichiedente = new EnteRichiedente()
    }

    void reset() {
        enteRichiedente = new EnteRichiedente()
        comuneEstero = Boolean.FALSE
    }
}