package it.finmatica.de4gsdzk.utils

enum EGradoParentela {

    // ANSC_43
    PD("PD"), // "Padre"
    MD("MD"), // "Madre"
    OP("OP"), // "Nonno paterno"
    AP("AP"), // "Nonna paterna"
    OM("OM"), // "Nonno materno"
    AM("AM")  // "Nonna materna"

    final String id

    private EGradoParentela(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case PD: return Etichette.Padre
            case MD: return Etichette.Madre
            case OP: return Etichette.Nonno_paterno
            case AP: return Etichette.Nonna_paterna
            case OM: return Etichette.Nonno_materno
            case AM: return Etichette.Nonna_materna
        }
        return null
    }
}