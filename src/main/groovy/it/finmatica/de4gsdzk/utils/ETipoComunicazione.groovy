package it.finmatica.de4gsdzk.utils

enum ETipoComunicazione {

    A("A"), // Atto
    N("N")  // Annotazione

    final String id

    private ETipoComunicazione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case A: return Etichette.getEtichetta("Atto")
            case N: return Etichette.getEtichetta("Annotazione")
        }
        return null
    }

    boolean isAnnotazione() { return this == N }

}