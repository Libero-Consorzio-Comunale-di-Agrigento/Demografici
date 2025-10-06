package it.finmatica.de4gsdzk.utils

enum EModalita {

    PAR, ARR, INT

    Map getEtichettaDesc() {
        switch(this) {
            case PAR: return Etichette.Modalita_PAR
            case ARR: return Etichette.Modalita_ARR
            case INT: return Etichette.Modalita_INT
        }
        return null
    }

}
