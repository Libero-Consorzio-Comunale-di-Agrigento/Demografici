package it.finmatica.de4gsdzk.utils

class RicercaComune {

    private final Date dataRiferimento

    private final String descrizioneComune
    private final Boolean searchEqual
    private final List<String> idNotIn

    RicercaComune(Date dataRiferimento, String descrizioneComune, Boolean searchEqual, List<String> idNotIn) {
        this.dataRiferimento = dataRiferimento
        this.descrizioneComune = descrizioneComune
        this.searchEqual = searchEqual
        this.idNotIn = idNotIn
    }

    Date getDataRiferimento() {
        return dataRiferimento
    }

    String getDescrizioneComune() {
        return descrizioneComune
    }

    Boolean getSearchEqual() {
        return searchEqual
    }

    List<String> getIdNotIn() {
        return idNotIn
    }
}
