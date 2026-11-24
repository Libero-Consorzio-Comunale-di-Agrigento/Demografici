package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.Etichette

enum EProgressivoTimbro {

    RICOMPILATE(1),
    RETTIFICHE(2),
    BLOCCO(3),
    A_L(8),
    M_Z(9)

    Integer id

    EProgressivoTimbro(Integer id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case RICOMPILATE: return Etichette.getEtichetta("Ricompilate")
            case RETTIFICHE: return Etichette.getEtichetta("Rettifiche")
            case BLOCCO: return Etichette.getEtichetta("Blocco")
            case A_L: return Etichette.getEtichetta("Lista_A_L")
            case M_Z: return Etichette.getEtichetta("Lista_M_Z")
        }
        return null
    }

}