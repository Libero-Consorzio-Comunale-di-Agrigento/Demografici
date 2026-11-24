package it.finmatica.de4gsdzk.utils

enum ETipoModello {

    C("C"), // Comunicazioni
    P("P"),  // Pratica
    F("F"),  // Convivenza di fatto
    E("E")  // Etichette

    final String id

    private ETipoModello(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case C: return Etichette.getEtichetta("Comunicazioni")
            case P: return Etichette.getEtichetta("Adempimenti_Pratica")
            case F: return Etichette.getEtichetta("Convivenza_di_fatto")
            case E: return Etichette.getEtichetta("Etichette")
        }
        return null
    }

}