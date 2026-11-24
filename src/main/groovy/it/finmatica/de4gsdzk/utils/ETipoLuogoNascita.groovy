package it.finmatica.de4gsdzk.utils

enum ETipoLuogoNascita {

    AE("AE"), // Aereo
    NA("NA"), // Nave
    TR("TR"), // Treno
    AL("AL")  // Altro

    final String id

    private ETipoLuogoNascita(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case AE: return Etichette.getEtichetta("Aereo")
            case NA: return Etichette.getEtichetta("Nave")
            case TR: return Etichette.getEtichetta("Treno")
            case AL: return Etichette.getEtichetta("Altro")
        }
        return null
    }
}
