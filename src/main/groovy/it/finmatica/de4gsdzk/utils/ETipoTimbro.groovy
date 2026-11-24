package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.Etichette

enum ETipoTimbro {

    UFFICIO_COMUNALE(1),
    COMMISSIONE_CIRCONDARIALE(2)

    Integer id

    ETipoTimbro(Integer id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case UFFICIO_COMUNALE: return Etichette.getEtichetta("Ufficio_Comunale")
            case COMMISSIONE_CIRCONDARIALE: return Etichette.getEtichetta("Commissione_Circondariale")
        }
        return null
    }

}