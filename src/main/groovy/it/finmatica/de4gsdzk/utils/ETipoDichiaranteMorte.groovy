package it.finmatica.de4gsdzk.utils

enum ETipoDichiaranteMorte {

    C1,     // Comparente 1 = Dichiarante (pre ANSC)
    C1IT,   // Comparente 1 e Interprete = Dichiarante e Interprete  (pre ANSC)
    NE      // Nessuno

    Map getEtichettaDesc(){
        switch(this) {
            case C1: return Etichette.getEtichetta("Dichiarante")
            case C1IT: return Etichette.getEtichetta("Dichiarante_e_Interprete")
            case NE: return Etichette.getEtichetta("Nessuno")
        }
        return null
    }

}