package it.finmatica.de4gsdzk.utils

enum ETipoEnteEmittente {

    // ANSC_20
    MI("MI", 1), // Ministero degli Interni
    CO("CO", 2)  // Comune

    final String id
    final Integer valore

    private ETipoEnteEmittente(String id, Integer valore) {
        this.id = id
        this.valore = valore
    }

    Map getEtichettaDesc(){
        switch(this) {
            case MI: return Etichette.Ministero_Interni
            case CO: return Etichette.Comune
        }
        return null
    }

}