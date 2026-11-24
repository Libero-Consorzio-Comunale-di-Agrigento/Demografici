package it.finmatica.de4gsdzk.utils

enum ETipoDichiaranteMatrimonioDivorzio {

    SO,         // Marito
    SA,         // Moglie
    SOSA,       // Marito e moglie
    SOIT,       // Marito e Interprete
    SAIT,       // Moglie e Interprete
    SOSAIT,     // Marito moglie e interprete
    IT,         // Interprete
    NE,         // Nessuno
    AL,         // Altro
    MC,         // Ministro di culto

    SOAA,       // Marito e avvocato moglie
    SOAO,       // Marito e avvocato marito
    SAAO,       // Moglie e avvocato marito
    SAAA,       // Moglie e avvocato moglie
    AO,         // Avvocato marito
    AA,         // Avvocato moglie
    AOAA,       // Avvocati
    SOSAAO,     // Coniugi e avvocato marito
    SOSAAA,     // Coniugi e avvocato moglie
    SOAOAA,     // Marito e avvocati
    SAAAAO,     // Moglie e avvocati
    SOSAAOAA    // Marito moglie e avvocati

    Map getEtichettaDesc(){
        switch(this) {
            // Matrimoni
            case SO: return Etichette.getEtichetta("Solo_Marito")
            case SA: return Etichette.getEtichetta("Solo_Moglie")
            case SOSA: return Etichette.getEtichetta("Marito_Moglie")
            case SOIT: return Etichette.getEtichetta("Marito_Interprete")
            case SAIT: return Etichette.getEtichetta("Moglie_Interprete")
            case SOSAIT: return Etichette.getEtichetta("Marito_Moglie_e_Interprete")
            case IT: return Etichette.getEtichetta("Interprete")
            case NE: return Etichette.getEtichetta("Nessuno")
            case AL: return Etichette.getEtichetta("Altro")
            case MC: return Etichette.getEtichetta("Ministro_culto")
            // Divorzi
            case SOAA: return Etichette.getEtichetta("Marito_e_Avvocato_Moglie")
            case SOAO: return Etichette.getEtichetta("Marito_e_Avvocato_Marito")
            case SAAO: return Etichette.getEtichetta("Moglie_e_Avvocato_Marito")
            case SAAA: return Etichette.getEtichetta("Moglie_e_Avvocato_Moglie")
            case AO: return Etichette.getEtichetta("Avvocato_Marito")
            case AA: return Etichette.getEtichetta("Avvocato_Moglie")
            case AOAA: return Etichette.getEtichetta("Solo_Avvocati")
            case SOSAAO: return Etichette.getEtichetta("Sposi_e_Avvocato_Marito")
            case SOSAAA: return Etichette.getEtichetta("Sposi_e_Avvocato_Moglie")
            case SOAOAA: return Etichette.getEtichetta("Marito_e_Avvocati")
            case SAAAAO: return Etichette.getEtichetta("Moglie_e_Avvocati")
            case SOSAAOAA: return Etichette.getEtichetta("Sposi_e_Avvocati")
        }
        return null
    }

}