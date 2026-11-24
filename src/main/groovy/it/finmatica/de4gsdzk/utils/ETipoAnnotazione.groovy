package it.finmatica.de4gsdzk.utils

enum ETipoAnnotazione {

    C("C"), // In calce
    M("M"), // A margine dell'atto
    A("A"), // Nel corpo dell'atto da formulario
    W("W")  // Nel corpo dell'atto da frammenti

    final String id

    private ETipoAnnotazione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case C: return Etichette.getEtichetta("In_calce")
            case M: return Etichette.getEtichetta("A_margine")
            case A: return Etichette.getEtichetta("In_corpo_atto_da_formulario")
            case W: return Etichette.getEtichetta("In_corpo_atto_da_frammenti")
        }
        return null
    }

}