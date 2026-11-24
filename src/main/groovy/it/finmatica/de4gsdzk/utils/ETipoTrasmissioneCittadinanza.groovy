package it.finmatica.de4gsdzk.utils

enum ETipoTrasmissioneCittadinanza {

    // ANSC_88
    PD("PD"), // Padre
    MD("MD"), // Madre
    EN("EN")  // Entrambi

    final String id

    private ETipoTrasmissioneCittadinanza(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case PD: return Etichette.getEtichetta("Padre")
            case MD: return Etichette.getEtichetta("Madre")
            case EN: return Etichette.getEtichetta("Entrambi")
        }
        return null
    }
}