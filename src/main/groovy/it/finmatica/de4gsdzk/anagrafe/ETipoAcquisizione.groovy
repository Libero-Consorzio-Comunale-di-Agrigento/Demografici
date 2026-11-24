package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

enum ETipoAcquisizione {

    F("F"),  // da File
    S("S")   // da Scanner

    final String id

    private ETipoAcquisizione(String id) {
        this.id = id
    }

    Map getEtichettaDesc() {
        switch(this) {
            case F: return Etichette.getEtichetta("Da_File")
            case S: return Etichette.getEtichetta("Da_Scanner")
        }
        return null
    }
}