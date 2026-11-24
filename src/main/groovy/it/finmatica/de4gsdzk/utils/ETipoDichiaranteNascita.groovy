package it.finmatica.de4gsdzk.utils

enum ETipoDichiaranteNascita {

    IN,     // Interessato
    PD,     // Padre
    MD,     // Madre
    EN,     // Entrambi
    AL,     // Altro
    AM,     // Autorità mittente
    PDMD,   // Padre e madre
    NE,     // Nessuno
    IT,     // Interprete
    PP,     // Procuratore padre
    PM,     // Procuratore madre
    PPMD,   // Procuratore padre e madre
    PMPD,   // Procuratore madre e padre
    INIT,   // Interessato e interprete
    PDIT,   // Padre e interprete
    MDIT,   // Madre e interprete
    PDMDIT, // Padre madre e interprete
    OS      // Personale Sanitario

    Map getEtichettaDesc(){
        switch(this) {
            case IN: return Etichette.getEtichetta("Interessato")
            case PD: return Etichette.getEtichetta("Padre")
            case MD: return Etichette.getEtichetta("Madre")
            case EN: return Etichette.getEtichetta("Entrambi")
            case AL: return Etichette.getEtichetta("Altro")
            case AM: return Etichette.getEtichetta("Autorita_mittente")
            case PDMD: return Etichette.getEtichetta("Padre_e_Madre")
            case NE: return Etichette.getEtichetta("Nessuno")
            case IT: return Etichette.getEtichetta("Interprete")
            case PP: return Etichette.getEtichetta("Procuratore_Padre")
            case PM: return Etichette.getEtichetta("Procuratore_Madre")
            case PPMD: return Etichette.getEtichetta("Procuratore_Padre_con_Madre")
            case PMPD: return Etichette.getEtichetta("Procuratore_Madre_con_Padre")
            case INIT: return Etichette.getEtichetta("Interessato_e_Interprete")
            case PDIT: return Etichette.getEtichetta("Padre_e_Interprete")
            case MDIT: return Etichette.getEtichetta("Madre_e_Interprete")
            case PDMDIT: return Etichette.getEtichetta("Padre_Madre_e_Interprete")
            case OS: return Etichette.getEtichetta("Personale_Sanitario")
        }
        return null
    }

}