package it.finmatica.de4gsdzk.utils

enum ETipoMargineLaterale {

    D("D"), // Destro"
    S("S")  // Sinistro

    final String id

    private ETipoMargineLaterale(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case D: return Etichette.getEtichetta("Destro")
            case S: return Etichette.getEtichetta("Sinistro")
        }
        return null
    }

}