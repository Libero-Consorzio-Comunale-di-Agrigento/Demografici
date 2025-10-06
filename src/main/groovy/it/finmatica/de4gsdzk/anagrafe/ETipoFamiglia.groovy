package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

enum ETipoFamiglia {
    FAMIGLIA,
    CONVIVENZA

    Map getEtichettaDesc() {
        switch (this) {
            case FAMIGLIA: return Etichette.Famiglia
            case CONVIVENZA: return Etichette.Convivenza
        }
        return null
    }

}