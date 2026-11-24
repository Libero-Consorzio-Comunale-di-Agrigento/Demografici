package it.finmatica.de4gsdzk.utils

enum EModalita {

    PAR, ARR, INT

    Map getEtichettaDesc() {
        switch(this) {
            case PAR: return Etichette.getEtichetta("Modalita_PAR")
            case ARR: return Etichette.getEtichetta("Modalita_ARR")
            case INT: return Etichette.getEtichetta("Modalita_INT")
        }
        return null
    }

}
