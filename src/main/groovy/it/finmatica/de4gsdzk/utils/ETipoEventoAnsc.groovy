package it.finmatica.de4gsdzk.utils

enum ETipoEventoAnsc {

    // ANSC_1
    NAS("NAS", 1),
    MOR("MOR", 2),
    MAT("MAT", 3),
    UCI("UCI", 4),
    CIT("CIT", 5)

    final String id
    final int valore

    private ETipoEventoAnsc(String id, int valore) {
        this.id = id
        this.valore = valore
    }

    Map getEtichettaDesc(){
        switch(this) {
            case NAS: return Etichette.getEtichetta("Atto_Nascita")
            case MOR: return Etichette.getEtichetta("Atto_Morte")
            case MAT: return Etichette.getEtichetta("Atto_Matrimonio")
            case UCI: return Etichette.getEtichetta("Atto_Unione_Civile")
            case CIT: return Etichette.getEtichetta("Atto_Cittadinanza")
        }
        return null
    }

    Map getEtichettaPluralDesc(){
        switch(this) {
            case NAS: return Etichette.getEtichetta("Atti_Nascita")
            case MOR: return Etichette.getEtichetta("Atti_Morte")
            case MAT: return Etichette.getEtichetta("Atti_Matrimonio")
            case UCI: return Etichette.getEtichetta("Atti_Unione_Civile")
            case CIT: return Etichette.getEtichetta("Atti_Cittadinanza")
        }
        return null
    }
}