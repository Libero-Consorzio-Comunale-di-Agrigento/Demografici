package it.finmatica.de4gsdzk.utils

enum ETipoRettifica {

    I("I"),
    F("F"),
    R("R")

    final String id

    private ETipoRettifica(String id) {
        this.id = id
    }

    Map getEtichettaDesc() {
        switch (this) {
            case I: return Etichette.getEtichetta("Dati_Individuo")
            case F: return Etichette.getEtichetta("Indirizzo_Famiglia")
            case R: return Etichette.getEtichetta("Rapporti_Parentela")
        }
        return null

    }
}