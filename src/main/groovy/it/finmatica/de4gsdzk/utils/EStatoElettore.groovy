package it.finmatica.de4gsdzk.utils

enum EStatoElettore {

    E("E"), // Elettore
    C("C"), // Cancellato
    S("S") // Sospeso

    String id

    EStatoElettore(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case E: return Etichette.getEtichetta("Elettore")
            case C: return Etichette.getEtichetta("Cancellato")
            case S: return Etichette.getEtichetta("Sospeso")
        }
        return null
    }

}