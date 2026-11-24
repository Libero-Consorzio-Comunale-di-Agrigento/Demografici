package it.finmatica.de4gsdzk.utils

enum ETipoFiliazione {

    L("L"), // Nel matrimonio
    C("C"), // Fuori matrimonio
    S("S")  // Senza riconoscimento

    final String id

    private ETipoFiliazione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case L: return Etichette.getEtichetta("Nel_Matrimonio")
            case C: return Etichette.getEtichetta("Fuori_Matrimonio")
            case S: return Etichette.getEtichetta("Senza_Riconoscimento")
        }
        return null
    }

}