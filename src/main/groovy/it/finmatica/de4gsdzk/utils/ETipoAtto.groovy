package it.finmatica.de4gsdzk.utils

enum ETipoAtto {

    NAS("NAS", 2),
    MAT("MAT", 4),
    PUB("PUB", 3),
    MOR("MOR", 5),
    UCI("UCI", -4),
    PVU("PVU", -4),
    CIT("CIT", 1),

    final String id
    final int valore

    private ETipoAtto(String id, int valore) {
        this.id = id
        this.valore = valore
    }

    Map getEtichettaDesc(){
        switch(this) {
            case NAS: return Etichette.Atto_Nascita
            case MAT: return Etichette.Atto_Matrimonio
            case PUB: return Etichette.Verbale_Pubblicazione
            case MOR: return Etichette.Atto_Morte
            case UCI: return Etichette.Atto_Unione_Civile
            case PVU: return Etichette.Processo_Verbale
            case CIT: return Etichette.Atto_Cittadinanza
        }
        return null
    }

    Map getEtichettaPluralDesc(){
        switch(this) {
            case NAS: return Etichette.Atti_Nascita
            case MAT: return Etichette.Atti_Matrimonio
            case PUB: return Etichette.Verbali_Pubblicazione
            case MOR: return Etichette.Atti_Morte
            case UCI: return Etichette.Atti_Unione_Civile
            case PVU: return Etichette.Processi_Verbali
            case CIT: return Etichette.Atti_Cittadinanza
        }
        return null
    }

    Boolean hasParte() {
        switch(this) {
            case CIT: case PUB: case PVU:
                return Boolean.FALSE
        }
        return Boolean.TRUE
    }

    Boolean hasSerie(){
        switch(this) {
            case CIT: case PUB: case PVU: case UCI:
                return Boolean.FALSE
        }
        return Boolean.TRUE
    }

    Boolean isAttoAnsc(){
        switch(this) {
            case NAS: case MAT: case UCI: case MOR: case CIT:
                return Boolean.TRUE
        }
        return Boolean.FALSE
    }

    Boolean isMatrimonio() {
        return (this == MAT)
    }

    Boolean isUnioneCivile() {
        return (this == UCI)
    }

    Boolean isMatUci(){
        return ( (this == MAT) || (this == UCI) )
    }

    Boolean isSingoloSoggetto() {
        return ( (this == NAS) || (this == MOR) || (this == CIT) )
    }

    Boolean isDoppioSoggetto() {
        return ( (this == PUB) || (this == MAT) || (this == PVU) || (this == UCI) )
    }

}