package it.finmatica.de4gsdzk.utils

@Deprecated
enum ETipoEmissioneCertificato {

    PAR("PAR"), // ISTANZA DI PARTE
    RIC("RIC"), // ALTRO RICHIEDENTE
    UFF("UFF")  // ISTANZA D'UFFICIO

    final String id

    private ETipoEmissioneCertificato(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case PAR: return Etichette.getEtichetta("ISTANZA_PARTE")
            case RIC: return Etichette.getEtichetta("ALTRO_RICHIEDENTE")
            case UFF: return Etichette.getEtichetta("ISTANZA_UFFICIO")
        }
        return null
    }

    Boolean isAltroRichiedente() {
        return (this == RIC)
    }

    Boolean isIstanzaDiParte() {
        return (this == PAR)
    }

    Boolean isIstanzaDiUfficio() {
        return (this == UFF)
    }

}