package it.finmatica.de4gsdzk.utils

enum ETipoAccordo {

    U("U"), // presso Ufficiale
    A("A")  // presso avvocati

    final String id

    private ETipoAccordo(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case U: return Etichette.c_o_Ufficiale
            case A: return Etichette.c_o_Avvocati
        }
        return null
    }

    boolean isPressoUfficiale(){
        return (this == U)
    }

    boolean isPressoAvvocati(){
        return (this == A)
    }
}