package it.finmatica.de4gsdzk.certificazione

class AnprRichiestaCertificatoResult {
    byte[] blob
    String error

    AnprRichiestaCertificatoResult(byte[] blob, String error) {
        this.blob = blob
        this.error = error
    }
}
