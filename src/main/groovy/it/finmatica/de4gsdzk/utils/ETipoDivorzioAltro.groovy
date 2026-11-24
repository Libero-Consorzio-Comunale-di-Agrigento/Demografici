package it.finmatica.de4gsdzk.utils

enum ETipoDivorzioAltro {

    M("M"), // Mancata conferma accordo
    C("C"), // Modifica condizioni di separazione
    D("D"), // Modifica condizioni di divorzio

    // per il momento solo per gli scioglimenti
    A("A")  // Altro

    final String id

    private ETipoDivorzioAltro(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case M: return Etichette.getEtichetta("Mancata_conferma_accordo")
            case C: return Etichette.getEtichetta("Modifica_condizioni_separazione")
            case D: return Etichette.getEtichetta("Modifica_condizioni_divorzio")
            case A: return Etichette.getEtichetta("Altro")
        }
        return null
    }

}