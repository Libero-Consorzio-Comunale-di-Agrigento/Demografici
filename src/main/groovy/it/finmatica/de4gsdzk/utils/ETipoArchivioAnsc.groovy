package it.finmatica.de4gsdzk.utils

enum ETipoArchivioAnsc {

    NAS("NAS"),
    MAT("MAT"),
    UCI("UCI"),
    MOR("MOR"),
    CIT("CIT"),
    ANN("ANN"),
    ALL("ALL"),
    CER("CER"),
    NOT("NOT"),
    FIR("FIR")

    final String id

    private ETipoArchivioAnsc(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case NAS: return Etichette.Atti_Nascita
            case MAT: return Etichette.Atti_Matrimonio
            case UCI: return Etichette.Atti_Unione_Civile
            case MOR: return Etichette.Atti_Morte
            case CIT: return Etichette.Atti_Cittadinanza
            case ANN: return Etichette.Annotazioni
            case ALL: return Etichette.Allegati
            case CER: return Etichette.Certificati
            case NOT: return Etichette.Notifiche
            case FIR: return Etichette.Firmatari
        }
        return null

    }

}