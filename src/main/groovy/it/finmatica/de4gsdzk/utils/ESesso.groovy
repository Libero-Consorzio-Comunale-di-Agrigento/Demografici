package it.finmatica.de4gsdzk.utils

enum ESesso {

    // ANSC_5 ma pre-esistente
    M("M"), // Maschio
    F("F")  // Femmina

    final String id

    private ESesso(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case M: return Etichette.Maschio
            case F: return Etichette.Femmina
        }
        return null
    }

}