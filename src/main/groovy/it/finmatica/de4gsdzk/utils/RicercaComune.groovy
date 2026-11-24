package it.finmatica.de4gsdzk.utils

class RicercaComune {

    private final Date dataRiferimento

    private final String descrizioneComune
    private final Boolean searchEqual
    private final List<String> idNotIn
    private final Boolean escludiSoppressi

    RicercaComune(Date dataRiferimento, String descrizioneComune, Boolean searchEqual, List<String> idNotIn, Boolean escludiSoppressi = false) {
        this.dataRiferimento = dataRiferimento
        this.descrizioneComune = descrizioneComune
        this.searchEqual = searchEqual
        this.idNotIn = idNotIn
        this.escludiSoppressi = escludiSoppressi
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

    Boolean getEscludiSoppressi() {
        return escludiSoppressi
    }
}
