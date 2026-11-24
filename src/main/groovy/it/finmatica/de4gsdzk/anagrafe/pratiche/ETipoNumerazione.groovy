package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.utils.Etichette

enum ETipoNumerazione {

    DEFINITIVA("D"),
    PROVVISORIA("P")


    final String id

    private ETipoNumerazione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case DEFINITIVA: return Etichette.getEtichetta("Definitiva")
            case PROVVISORIA: return Etichette.getEtichetta("Provvisoria")
        }
        return null
    }

}
