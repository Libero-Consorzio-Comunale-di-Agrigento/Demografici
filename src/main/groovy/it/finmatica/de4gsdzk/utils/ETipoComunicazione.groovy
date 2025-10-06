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
            case A: return Etichette.Atto
            case N: return Etichette.Annotazione
        }
        return null
    }

    boolean isAnnotazione() { return this == N }

}