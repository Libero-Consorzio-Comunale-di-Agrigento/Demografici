package it.finmatica.de4gsdzk.utils

enum ETipoIndice {

    A("A"), // Indici Annuali
    D("D")  // Indici Decennali

    final String id

    private ETipoIndice(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case A: return Etichette.getEtichetta("Indici_Annuali")
            case D: return Etichette.getEtichetta("Indici_Decennali")
        }
        return null
    }

}