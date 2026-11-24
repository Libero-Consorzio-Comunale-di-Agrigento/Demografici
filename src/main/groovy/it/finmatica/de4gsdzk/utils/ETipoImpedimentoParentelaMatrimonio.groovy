package it.finmatica.de4gsdzk.utils

enum ETipoImpedimentoParentelaMatrimonio {

    // ANSC_48
    I0("I0"), // Nessun impedimento
    I1("I1"), // Impedimento della parentela
    I2("I2"), // Impedimento di affinita
    I3("I3")  // Impedimento di affiliazione

    final String id

    private ETipoImpedimentoParentelaMatrimonio(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case I0: return Etichette.getEtichetta("Nessun_impedimento")
            case I1: return Etichette.getEtichetta("Impedimento_parentela")
            case I2: return Etichette.getEtichetta("Impedimento_affinita")
            case I3: return Etichette.getEtichetta("Impedimento_affiliazione")
        }
        return null
    }

}