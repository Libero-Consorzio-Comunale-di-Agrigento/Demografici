package it.finmatica.de4gsdzk.utils

enum EStatoProtocollazione {

    D ("D"),
    P ("P")

    final String id

    private EStatoProtocollazione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case D: return Etichette.Da_Protocollare
            case P: return Etichette.Protocollato
        }
        return null
    }

}