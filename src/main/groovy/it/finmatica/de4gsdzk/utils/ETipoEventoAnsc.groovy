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
            case NAS: return Etichette.Atto_Nascita
            case MOR: return Etichette.Atto_Morte
            case MAT: return Etichette.Atto_Matrimonio
            case UCI: return Etichette.Atto_Unione_Civile
            case CIT: return Etichette.Atto_Cittadinanza
        }
        return null
    }

    Map getEtichettaPluralDesc(){
        switch(this) {
            case NAS: return Etichette.Atti_Nascita
            case MOR: return Etichette.Atti_Morte
            case MAT: return Etichette.Atti_Matrimonio
            case UCI: return Etichette.Atti_Unione_Civile
            case CIT: return Etichette.Atti_Cittadinanza
        }
        return null
    }
}