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
            case IN: return Etichette.Interessato
            case PD: return Etichette.Padre
            case MD: return Etichette.Madre
            case EN: return Etichette.Entrambi
            case AL: return Etichette.Altro
            case AM: return Etichette.Autorita_mittente
            case PDMD: return Etichette.Padre_e_Madre
            case NE: return Etichette.Nessuno
            case IT: return Etichette.Interprete
            case PP: return Etichette.Procuratore_Padre
            case PM: return Etichette.Procuratore_Madre
            case PPMD: return Etichette.Procuratore_Padre_con_Madre
            case PMPD: return Etichette.Procuratore_Madre_con_Padre
            case INIT: return Etichette.Interessato_e_Interprete
            case PDIT: return Etichette.Padre_e_Interprete
            case MDIT: return Etichette.Madre_e_Interprete
            case PDMDIT: return Etichette.Padre_Madre_e_Interprete
            case OS: return Etichette.Personale_Sanitario
        }
        return null
    }

}