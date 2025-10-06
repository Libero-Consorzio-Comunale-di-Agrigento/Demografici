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
            case AE: return Etichette.Aereo
            case NA: return Etichette.Nave
            case TR: return Etichette.Treno
            case AL: return Etichette.Altro
        }
        return null
    }
}
