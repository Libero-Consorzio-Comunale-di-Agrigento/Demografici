package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto

class DatiValidazioneEstremi {
    ETipoAtto tipoAtto
    EstremiAtto estremiAtto
    boolean estremiMandatory
    boolean ufficioMandatory

    DatiValidazioneEstremi(ETipoAtto tipoAtto,
                           EstremiAtto estremiAtto,
                           boolean estremiMandatory,
                           boolean ufficioMandatory) {
        this.tipoAtto = tipoAtto
        this.estremiAtto = estremiAtto
        this.estremiMandatory = estremiMandatory
        this.ufficioMandatory = ufficioMandatory
    }

    Integer getNumeroAtto() {
        return estremiAtto.atto
    }

    Integer getAnnoAtto() {
        return estremiAtto.anno
    }

    Integer getParteAtto() {
        return estremiAtto.parte
    }

    String getSerieAtto() {
        return estremiAtto.serie
    }

    String getIdAttoAnsc() {
        return estremiAtto.idAttoAnsc
    }

    String getUfficioAtto() {
        return estremiAtto.ufficio
    }
}
