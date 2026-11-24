package it.finmatica.de4gsdzk.utils

enum ETipoDichiarantePubblicazione {

    SO,  // "Solo_Sposo"
    SA,  // "Solo_Sposa"
    SI,  // "Entrambi"
    AL   // "Altro"

    Map getEtichettaDesc(){
        switch(this) {
            case SO: return Etichette.getEtichetta("Solo_Sposo")
            case SA: return Etichette.getEtichetta("Solo_Sposa")
            case SI: return Etichette.getEtichetta("Entrambi")
            case AL: return Etichette.getEtichetta("Altro")
        }
        return null
    }

}