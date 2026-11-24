package it.finmatica.de4gsdzk.utils

enum EDocumentoMatrimonio {

    UNO("UNO"), // Uno
    DUE("DUE"), // Due
    OME("OME"), // Omessa Pubblicazione
    ALT("ALT")  // Altro

    final String id

    private EDocumentoMatrimonio(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case UNO: return Etichette.getEtichetta("UNO")
            case DUE: return Etichette.getEtichetta("DUE")
            case OME: return Etichette.getEtichetta("OMESSA_PUBBLICAZIONE")
            case ALT: return Etichette.getEtichetta("Altro")
        }
        return null
    }

    boolean isUno(){
        return (this == UNO)
    }

    boolean isDue(){
        return (this == DUE)
    }

    boolean isOmessaPubblicazione(){
        return (this == OME)
    }

    boolean isAltro(){
        return (this == ALT)
    }
}