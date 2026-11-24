package it.finmatica.de4gsdzk.utils

enum ETipoEnteDestinatario {

    ENTE,
    COMUNE,
    CONSOLATO,
    INDIVIDUO

    Map getEtichettaDesc(){
        switch(this) {
            case ENTE: return Etichette.getEtichetta("ENTE")
            case COMUNE: return Etichette.getEtichetta("COMUNE")
            case CONSOLATO: return Etichette.getEtichetta("CONSOLATO")
            case INDIVIDUO: return Etichette.getEtichetta("INDIVIDUO")
        }
        return null
    }

    boolean isComune(){
        return (this == COMUNE)
    }

    boolean isEnte(){
        return (this == ENTE)
    }

}