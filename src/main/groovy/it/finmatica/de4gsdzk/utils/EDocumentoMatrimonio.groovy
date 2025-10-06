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
            case UNO: return Etichette.UNO
            case DUE: return Etichette.DUE
            case OME: return Etichette.OMESSA_PUBBLICAZIONE
            case ALT: return Etichette.Altro
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