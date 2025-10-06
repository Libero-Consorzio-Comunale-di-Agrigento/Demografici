package it.finmatica.de4gsdzk.utils

enum ETipoEnteDestinatario {

    ENTE,
    COMUNE,
    CONSOLATO,
    INDIVIDUO

    Map getEtichettaDesc(){
        switch(this) {
            case ENTE: return Etichette.ENTE
            case COMUNE: return Etichette.COMUNE
            case CONSOLATO: return Etichette.CONSOLATO
            case INDIVIDUO: return Etichette.INDIVIDUO
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