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
            case NAS: return Etichette.getEtichetta("Atti_Nascita")
            case MAT: return Etichette.getEtichetta("Atti_Matrimonio")
            case UCI: return Etichette.getEtichetta("Atti_Unione_Civile")
            case MOR: return Etichette.getEtichetta("Atti_Morte")
            case CIT: return Etichette.getEtichetta("Atti_Cittadinanza")
            case ANN: return Etichette.getEtichetta("Annotazioni")
            case ALL: return Etichette.getEtichetta("Allegati")
            case CER: return Etichette.getEtichetta("Certificati")
            case NOT: return Etichette.getEtichetta("Notifiche")
            case FIR: return Etichette.getEtichetta("Firmatari")
        }
        return null

    }

    ETipoAtto getTipoAtto(){
        switch(this) {
            case NAS: return ETipoAtto.NAS
            case MAT: return ETipoAtto.MAT
            case UCI: return ETipoAtto.UCI
            case MOR: return ETipoAtto.MOR
            case CIT: return ETipoAtto.CIT
        }
        return null

    }

}