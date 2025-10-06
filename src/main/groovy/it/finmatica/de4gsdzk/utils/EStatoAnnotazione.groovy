package it.finmatica.de4gsdzk.utils

enum EStatoAnnotazione {

    E("E"),  // Eseguita
    P("P")   // Proposta

    final String id

    private EStatoAnnotazione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case E: return Etichette.Eseguita
            case P: return Etichette.Proposta
        }
        return null
    }

}