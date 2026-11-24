package it.finmatica.de4gsdzk.utils

enum ETipoDivorzio {

    X("X"), // Separazione
    C("C"), // Cessazione
    S("S"), // Scioglimento
    A("A")  // Altro

    final String id

    private ETipoDivorzio(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case X: return Etichette.getEtichetta("Separazione")
            case C: return Etichette.getEtichetta("Cessazione")
            case S: return Etichette.getEtichetta("Scioglimento")
            case A: return Etichette.getEtichetta("Altro")
        }
        return null
    }

}