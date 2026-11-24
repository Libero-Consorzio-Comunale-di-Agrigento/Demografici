package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.Etichette

enum ETipoLista {

    GEN("GEN"), // Generale
    SEZ("SEZ") // Sezionale

    String id

    ETipoLista(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case GEN: return Etichette.getEtichetta("Generale")
            case SEZ: return Etichette.getEtichetta("Sezionale")
        }
        return null
    }

}