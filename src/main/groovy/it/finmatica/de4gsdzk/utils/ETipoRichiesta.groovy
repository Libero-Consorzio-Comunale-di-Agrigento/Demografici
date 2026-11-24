package it.finmatica.de4gsdzk.utils

enum ETipoRichiesta {

    // Cittadinanze
    // DAQ
    DIC("DIC"), // Dichiarazione
    TRA("TRA"),  // Trascrizione

    // Nascite
    // ADO
    ADO("ADO"), // Adozione
    REV("REV")  // Revoca

    final String id

    private ETipoRichiesta(String id) {
        this.id = id
    }

    // TODO: obsoletare in favore della descrizione su CivCategoriaTipoRichiesta
    Map getEtichettaDesc(){
        switch(this) {
            case DIC: return Etichette.getEtichetta("Dichiarazione")
            case TRA: return Etichette.getEtichetta("Trascrizione")
            case ADO: return Etichette.getEtichetta("Adozione")
            case REV: return Etichette.getEtichetta("Revoca")
        }
        return null
    }

}