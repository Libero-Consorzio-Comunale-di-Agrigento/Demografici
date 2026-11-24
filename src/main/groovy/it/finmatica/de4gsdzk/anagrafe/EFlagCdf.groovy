package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

enum EFlagCdf {
    S("S"),  // Istituzione
    R("R")   // Risoluzione

    final String id

    private EFlagCdf(String id) {
        this.id = id
    }

    Map getEtichettaDesc() {
        switch (this) {
            case R: return Etichette.getEtichetta("Risoluzione")
            case S: return Etichette.getEtichetta("Istituzione")
        }
        return null
    }
}

