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
            case C1: return Etichette.Contraente_1
            case C2: return Etichette.Contraente_2
            case SO: return Etichette.Sposo
            case SA: return Etichette.Sposa
            case EN: return Etichette.Entrambi
        }
        return null
    }

}