package it.finmatica.de4gsdzk.utils

enum ETipoConsensoRiconoscimento {

    // ANSC_12
    // nei riconoscimenti pre/post-nascita
    EV("EV"), // Contestuale all'evento
    AU("AU"), // consenso reso anteriormente davanti all'USC
    AA("AA"), // consenso reso anteriormente davanti ad altro Pubblico Ufficiale
    SR("SR")  // sentenza del tribunale dopo rifiuto consenso materno

    final String id

    private ETipoConsensoRiconoscimento(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case EV: return Etichette.contestuale_evento
            case AU: return Etichette.anteriormente_usc
            case AA: return Etichette.anteriormente_pu
            case SR: return Etichette.sentenza_dopo_rifiuto
        }
        return null
    }

}