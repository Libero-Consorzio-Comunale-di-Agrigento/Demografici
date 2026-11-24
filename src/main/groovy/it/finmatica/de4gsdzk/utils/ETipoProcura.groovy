package it.finmatica.de4gsdzk.utils

enum ETipoProcura {

    //ANSC_33
    MD("MD"), // Madre
    PD("PD"), // Padre

    final String id

    private ETipoProcura(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case MD: return Etichette.getEtichetta("Madre")
            case PD: return Etichette.getEtichetta("Padre")
        }
        return null
    }

}