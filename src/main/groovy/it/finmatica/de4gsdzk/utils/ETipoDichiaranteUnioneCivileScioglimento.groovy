package it.finmatica.de4gsdzk.utils

enum ETipoDichiaranteUnioneCivileScioglimento {

    C1,         // Contraente 1
    C2,         // Contraente 2
    C1C2,       // Contraente 1 e contraente 2
    C1IT,       // Contraente 1 e interprete
    C2IT,       // Contraente 2 e interprete
    C1C2IT,     // Contraente 1 contraente 2 e interprete
    IT,         // Interprete
    NE,         // Nessuno
    CI, // per retrocompatibilità con la precedente gestione degli scioglimenti

    C1A2,       // Contraente 1 e avvocato contraente 2
    C1A1,       // Contraente 1 e avvocato contraente 1
    C2A1,       // Contraente 2 e avvocato contraente 1
    C2A2,       // Contraente 2 e avvocato contraente 2
    A1,         // Avvocato contraente 1
    A2,         // Avvocato contraente 2
    A1A2,       // Avvocati
    C1C2A1,     // Contraente 1 contraente 2 e avvocato contraente 1
    C1C2A2,     // Contraente 1 contraente 2 e avvocato contraente 2
    C1A1A2,     // Contraente 1 Avvocato contraente 1 e avvocato contraente 2
    C2A2A1,     // Contraente 2 Avvocato contraente 2 e avvocato contraente 1
    C1C2A1A2    // Contraenti e avvocati

    Map getEtichettaDesc(){
        switch(this) {
            // unioni civili
            case C1: return Etichette.getEtichetta("Contraente_1")
            case C2: return Etichette.getEtichetta("Contraente_2")
            case C1C2: return Etichette.getEtichetta("Contraente_1_Contraente_2")
            case C1IT: return Etichette.getEtichetta("Contraente_1_e_Interprete")
            case C2IT: return Etichette.getEtichetta("Contraente_2_e_Interprete")
            case C1C2IT: return Etichette.getEtichetta("Contraente_1_Contraente_2_e_Interprete")
            case IT: return Etichette.getEtichetta("Interprete")
            case NE: return Etichette.getEtichetta("Nessuno")
            case CI: return Etichette.getEtichetta("Contraente_1_Contraente_2") // per retrocompatibilità
            // scioglimenti
            case C1A2: return Etichette.getEtichetta("Contraente_1_e_Avvocato_Contraente_2")
            case C1A1: return Etichette.getEtichetta("Contraente_1_e_Avvocato_Contraente_1")
            case C2A1: return Etichette.getEtichetta("Contraente_2_e_Avvocato_Contraente_1")
            case C2A2: return Etichette.getEtichetta("Contraente_2_e_Avvocato_Contraente_2")
            case A1: return Etichette.getEtichetta("Avvocato_Contraente_1")
            case A2: return Etichette.getEtichetta("Avvocato_Contraente_2")
            case A1A2: return Etichette.getEtichetta("Avvocati_Contraenti")
            case C1C2A1: return Etichette.getEtichetta("Contraente_1_Contraente_2_Avvocato_Contraente_1")
            case C1C2A2: return Etichette.getEtichetta("Contraente_1_Contraente_2_Avvocato_Contraente_2")
            case C1A1A2: return Etichette.getEtichetta("Contraente_1_e_Avvocati")
            case C2A2A1: return Etichette.getEtichetta("Contraente_2_e_Avvocati")
            case C1C2A1A2: return Etichette.getEtichetta("Contraenti_e_Avvocati")
        }
        return null
    }

}