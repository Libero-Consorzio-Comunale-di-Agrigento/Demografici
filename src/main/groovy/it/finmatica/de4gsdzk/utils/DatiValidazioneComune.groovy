package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.embed.Comune

class DatiValidazioneComune {
    Integer codiceComune
    Integer codiceProvincia
    boolean comuneMandatory

    DatiValidazioneComune(Integer codiceComune, Integer codiceProvincia, boolean comuneMandatory) {
        this.codiceComune = codiceComune
        this.codiceProvincia = codiceProvincia
        this.comuneMandatory = comuneMandatory
    }

    DatiValidazioneComune(Comune comune, boolean comuneMandatory) {
        this(comune.codice, comune.codiceProvincia, comuneMandatory)
    }
}
