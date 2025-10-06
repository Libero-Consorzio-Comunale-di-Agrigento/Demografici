package it.finmatica.de4gsdzk.utils

class DatiValidazioneAnnotazione {
    DatiValidazioneEstremi datiValidazioneEstremi
    DatiValidazioneComune datiValidazioneComune
    DatiValidazioneDataAtto datiValidazioneDataAtto
    String formula
    boolean datiAnnotazioneMandatory
    boolean formulaMandatory

    DatiValidazioneAnnotazione(DatiValidazioneEstremi datiValidazioneEstremi,
                               DatiValidazioneComune datiValidazioneComune,
                               DatiValidazioneDataAtto datiValidazioneDataAtto,
                               String formula,
                               boolean datiAnnotazioneMandatory,
                               boolean formulaMandatory) {
        this.datiValidazioneEstremi = datiValidazioneEstremi
        this.datiValidazioneComune = datiValidazioneComune
        this.datiValidazioneDataAtto = datiValidazioneDataAtto
        this.formula = formula
        this.datiAnnotazioneMandatory = datiAnnotazioneMandatory
        this.formulaMandatory = formulaMandatory
    }

    ETipoAtto getTipoAtto() {
        return datiValidazioneEstremi.tipoAtto
    }

    Integer getNumeroAtto() {
        return datiValidazioneEstremi.estremiAtto.atto
    }

    Integer getAnnoAtto() {
        return datiValidazioneEstremi.estremiAtto.anno
    }

    Integer getParteAtto() {
        return datiValidazioneEstremi.estremiAtto.parte
    }

    String getSerieAtto() {
        return datiValidazioneEstremi.estremiAtto.serie
    }

    String getIdAttoAnsc() {
        return datiValidazioneEstremi.estremiAtto.idAttoAnsc
    }

    String getUfficioAtto() {
        return datiValidazioneEstremi.estremiAtto.ufficio
    }

    boolean getUfficioMandatory() {
        return datiValidazioneEstremi.ufficioMandatory
    }

    Integer getCodiceComune() {
        return datiValidazioneComune.codiceComune
    }

    Integer getCodiceProvincia() {
        return datiValidazioneComune.codiceProvincia
    }

    boolean getComuneMandatory() {
        return datiValidazioneComune.comuneMandatory
    }

    Date getDataAtto() {
        return datiValidazioneDataAtto.dataAtto
    }

    boolean getDataAttoMandatory() {
        return datiValidazioneDataAtto.dataAttoMandatory
    }
}
