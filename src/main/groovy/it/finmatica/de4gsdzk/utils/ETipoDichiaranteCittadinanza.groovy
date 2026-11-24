package it.finmatica.de4gsdzk.utils

enum ETipoDichiaranteCittadinanza {

    IN,     // Intestatario
    IT,     // Interprete
    DE,     // Delegato
    DEIT,   // Delegato e Interprete
    DEIN,   // Delegato e Intestatario
    INIT,   // Intestatario e Interprete
    DEINIT, // Delegato intestatario e interprete
    NE      // Nessuno

    Map getEtichettaDesc(){
        switch(this) {
            case IN: return Etichette.getEtichetta("Intestatario")
            case IT: return Etichette.getEtichetta("Interprete")
            case DE: return Etichette.getEtichetta("Delegato")
            case DEIT: return Etichette.getEtichetta("Delegato_e_Interprete")
            case DEIN: return Etichette.getEtichetta("Delegato_e_Intestatario")
            case INIT: return Etichette.getEtichetta("Intestatario_e_Interprete")
            case DEINIT: return Etichette.getEtichetta("Delegato_Intestatario_e_Interprete")
            case NE: return Etichette.getEtichetta("Nessuno")
        }
        return null
    }

}