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
            case IN: return Etichette.Intestatario
            case IT: return Etichette.Interprete
            case DE: return Etichette.Delegato
            case DEIT: return Etichette.Delegato_e_Interprete
            case DEIN: return Etichette.Delegato_e_Intestatario
            case INIT: return Etichette.Intestatario_e_Interprete
            case DEINIT: return Etichette.Delegato_Intestatario_e_Interprete
            case NE: return Etichette.Nessuno
        }
        return null
    }

}