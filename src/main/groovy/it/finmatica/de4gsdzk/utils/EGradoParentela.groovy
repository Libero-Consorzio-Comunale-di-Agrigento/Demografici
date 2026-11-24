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
            case PD: return Etichette.getEtichetta("Padre")
            case MD: return Etichette.getEtichetta("Madre")
            case OP: return Etichette.getEtichetta("Nonno_paterno")
            case AP: return Etichette.getEtichetta("Nonna_paterna")
            case OM: return Etichette.getEtichetta("Nonno_materno")
            case AM: return Etichette.getEtichetta("Nonna_materna")
        }
        return null
    }
}