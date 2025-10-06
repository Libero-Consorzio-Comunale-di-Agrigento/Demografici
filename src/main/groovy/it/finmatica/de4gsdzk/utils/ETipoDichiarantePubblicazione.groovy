package it.finmatica.de4gsdzk.utils

enum ETipoDichiarantePubblicazione {

    SO,  // "Solo_Sposo"
    SA,  // "Solo_Sposa"
    SI,  // "Entrambi"
    AL   // "Altro"

    Map getEtichettaDesc(){
        switch(this) {
            case SO: return Etichette.Solo_Sposo
            case SA: return Etichette.Solo_Sposa
            case SI: return Etichette.Entrambi
            case AL: return Etichette.Altro
        }
        return null
    }

}