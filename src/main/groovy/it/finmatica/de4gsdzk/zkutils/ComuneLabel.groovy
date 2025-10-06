package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.statocivile.embed.Comune
import org.zkoss.zk.ui.select.Selectors

class ComuneLabel extends CustomLabel {

    Comune comune

    ComuneLabel() {
        super()

        Selectors.wireVariables(this, this, null)
        Selectors.wireComponents(this, this, false)
        Selectors.wireEventListeners(this, this)
    }

    @Override
    void setValue(def value) {
        comune = value as Comune
        if (comune == null) {
            super.setValue(null)
            return
        }

        if (comune.descrizione == null && comune.siglaProvincia == null) {
            super.setValue(null)
            return
        }

        super.setValue("${comune.descrizione ? comune.descrizione : ''}${comune.siglaProvincia ? " (${comune.siglaProvincia})" : ''}")
    }

    @Override
    def getValue() {
        return comune
    }
}