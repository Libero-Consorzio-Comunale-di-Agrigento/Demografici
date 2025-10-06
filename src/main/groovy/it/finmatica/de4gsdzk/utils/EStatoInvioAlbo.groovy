package it.finmatica.de4gsdzk.utils

enum EStatoInvioAlbo {

    D("D"), // Da inviare all'albo pretorio
    I("I")  // Inviato all'albo pretorio

    final String id

    private EStatoInvioAlbo(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case D: return Etichette.Da_Inviare_Albo
            case I: return Etichette.Inviato_Albo
        }
        return null
    }

}