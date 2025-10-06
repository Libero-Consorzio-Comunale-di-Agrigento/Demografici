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
            case X: return Etichette.Separazione
            case C: return Etichette.Cessazione
            case S: return Etichette.Scioglimento
            case A: return Etichette.Altro
        }
        return null
    }

}