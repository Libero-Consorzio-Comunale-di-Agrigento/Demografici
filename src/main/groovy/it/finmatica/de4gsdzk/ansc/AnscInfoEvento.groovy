package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.ETipoContenutoAnsc
import it.finmatica.de4gsdzk.utils.ETipologiaAnsc

class AnscInfoEvento {

    private final String idAnsc
    private final ETipoContenutoAnsc tipoContenutoAnsc
    private final String testo


    private ETipologiaAnsc tipologiaAnscPrimario
    private Comune comunePrimario
    private EstremiAtto estremiAttoPrimario

    AnscInfoEvento(String idAnsc,
                   ETipoContenutoAnsc tipoContenutoAnsc,
                   String testo) {
        this.idAnsc = idAnsc
        this.tipoContenutoAnsc = tipoContenutoAnsc
        this.testo = testo
    }

    void setPrimario(ETipologiaAnsc tipologiaAnscPrimario, Comune comunePrimario, EstremiAtto estremiAttoPrimario) {
        this.tipologiaAnscPrimario = tipologiaAnscPrimario
        this.comunePrimario = comunePrimario
        this.estremiAttoPrimario = estremiAttoPrimario
    }


    String getIdAnsc() {
        return idAnsc
    }

    ETipoContenutoAnsc getTipoContenutoAnsc() {
        return tipoContenutoAnsc
    }

    String getTesto() {
        return testo
    }

    ETipologiaAnsc getTipologiaAnscCollegato() {
        return tipologiaAnscCollegato
    }

    Comune getComuneCollegato() {
        return comuneCollegato
    }

    Date getDataFormazioneCollegato() {
        return dataFormazioneCollegato
    }

    EstremiAtto getEstremiAttoCollegato() {
        return estremiAttoCollegato
    }

    ETipologiaAnsc getTipologiaAnscPrimario() {
        return tipologiaAnscPrimario
    }

    Comune getComunePrimario() {
        return comunePrimario
    }

    Date getDataFormazionePrimario() {
        return dataFormazionePrimario
    }

    EstremiAtto getEstremiAttoPrimario() {
        return estremiAttoPrimario
    }
}
