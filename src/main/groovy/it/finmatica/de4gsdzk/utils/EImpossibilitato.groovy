package it.finmatica.de4gsdzk.utils

enum EImpossibilitato {

    C1("C1"), // Contraente 1
    C2("C2"), // Contraente 2
    SO("SO"), // Sposo
    SA("SA"), // Sposa
    EN("EN")  // Entrambi

    final String id

    private EImpossibilitato(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case C1: return Etichette.getEtichetta("Contraente_1")
            case C2: return Etichette.getEtichetta("Contraente_2")
            case SO: return Etichette.getEtichetta("Sposo")
            case SA: return Etichette.getEtichetta("Sposa")
            case EN: return Etichette.getEtichetta("Entrambi")
        }
        return null
    }

}