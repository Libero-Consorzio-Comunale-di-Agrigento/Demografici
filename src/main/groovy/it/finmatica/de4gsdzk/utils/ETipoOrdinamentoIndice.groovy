package it.finmatica.de4gsdzk.utils

enum ETipoOrdinamentoIndice {

    M_C1("M_C1"), // "Solo Maschi/Contraente 1"
    F_C2("F_C2"), // "Solo Femmine/Contraente 2"
    EN("EN")      // Entrambi

    final String id

    private ETipoOrdinamentoIndice(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case M_C1: return Etichette.getEtichetta("M_C1")
            case F_C2: return Etichette.getEtichetta("F_C2")
            case EN: return Etichette.getEtichetta("Entrambi")
        }
        return null
    }

    Boolean isEntrambi() {
        return (this == EN)
    }

}