package it.finmatica.de4gsdzk.utils

enum ETipoConsenso {

    CM("CM"), // con_consenso_materno
    CP("CP"), // con_consenso_paterno
    SM("SM"), // senza_consenso_materno
    SP("SP"), // senza_consenso_paterno

    // nei riconoscimenti post-nascita
    IG("IG")  // figlio di ignoti

    final String id

    private ETipoConsenso(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case CM: return Etichette.con_consenso_materno
            case CP: return Etichette.con_consenso_paterno
            case SM: return Etichette.senza_consenso_materno
            case SP: return Etichette.senza_consenso_paterno
            case IG: return Etichette.figlio_ignoti
        }
        return null
    }

}