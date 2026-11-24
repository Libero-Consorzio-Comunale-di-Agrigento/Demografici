package it.finmatica.de4gsdzk.utils

enum ETipoAssenso {

    // ANSC_37
    OR("OR"), // "orale"
    UF("UF")  // "altro_ufficiale"

    final String id

    private ETipoAssenso(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case OR: return Etichette.getEtichetta("orale")
            case UF: return Etichette.getEtichetta("altro_ufficiale")
        }
        return null
    }

}