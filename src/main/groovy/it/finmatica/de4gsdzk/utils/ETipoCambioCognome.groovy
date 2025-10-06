package it.finmatica.de4gsdzk.utils

enum ETipoCambioCognome {

    A("A"),
    P("P")

    final String id

    private ETipoCambioCognome(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case A: return Etichette.Antepone
            case P: return Etichette.Pospone
        }
        return null
    }

}