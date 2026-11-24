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
            case PR: return Etichette.getEtichetta("Prodotti")
            case AC: return Etichette.getEtichetta("Acquisiti")
            case VI: return Etichette.getEtichetta("Visionati")
        }
        return null
    }

}