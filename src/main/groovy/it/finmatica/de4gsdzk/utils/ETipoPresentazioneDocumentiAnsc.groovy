package it.finmatica.de4gsdzk.utils

enum ETipoPresentazioneDocumentiAnsc {

    // ANSC_36 ma pre-esistente
    PR("PR"), // Prodotti
    AC("AC"), // Acquisiti
    VI("VI")  // Visionati

    final String id

    private ETipoPresentazioneDocumentiAnsc(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case PR: return Etichette.Prodotti
            case AC: return Etichette.Acquisiti
            case VI: return Etichette.Visionati
        }
        return null
    }

}