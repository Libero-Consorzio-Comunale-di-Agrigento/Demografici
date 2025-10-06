package it.finmatica.de4gsdzk.utils

enum EImpedimentoGenericoUnioneCivile {

    // Rappresenta l'equivalente, per le Uci, del difetto d'età o dell'impedimento della parentela dei matrimoni
    NE("NE"), // Nessuno
    C1("C1"), // Contraente 1
    C2("C2"), // Contraente 2
    EN("EN")  // Entrambi

    final String id

    private EImpedimentoGenericoUnioneCivile(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case NE: return Etichette.Nessuno
            case C1: return Etichette.Contraente_1
            case C2: return Etichette.Contraente_2
            case EN: return Etichette.Entrambi
        }
        return null
    }

}