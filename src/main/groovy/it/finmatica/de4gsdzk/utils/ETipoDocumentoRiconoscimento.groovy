package it.finmatica.de4gsdzk.utils

enum ETipoDocumentoRiconoscimento {

    // ANSC_25
    PT("PT"), // "Patente"
    PP("PP"), // "Passaporto"
    CI("CI")  // "Carta Identita"

    final String id

    private ETipoDocumentoRiconoscimento(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case PT: return Etichette.getEtichetta("Patente")
            case PP: return Etichette.getEtichetta("Passaporto")
            case CI: return Etichette.getEtichetta("Carta_Identita")
        }
        return null
    }

}