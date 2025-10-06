package it.finmatica.de4gsdzk.utils

class RicercaSoggetto {

    String cognome
    String nome
    String codiceFiscale

    ESesso sesso
    Date dataNascita

    Long idSoggettoAnpr

    EArchivioSorgenteSoggetto archivio

    RicercaSoggetto(String cognome, String nome, String codiceFiscale, ESesso sesso, Date dataNascita, Long idSoggettoAnpr, EArchivioSorgenteSoggetto archivio) {
        this.cognome = cognome
        this.nome = nome
        this.codiceFiscale = codiceFiscale
        this.sesso = sesso
        this.dataNascita = dataNascita
        this.idSoggettoAnpr = idSoggettoAnpr
        this.archivio = archivio
    }

}
