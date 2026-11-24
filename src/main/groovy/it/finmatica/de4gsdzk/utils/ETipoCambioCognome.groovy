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
            case A: return Etichette.getEtichetta("Antepone")
            case P: return Etichette.getEtichetta("Pospone")
        }
        return null
    }

}