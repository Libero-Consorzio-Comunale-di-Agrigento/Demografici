package it.finmatica.de4gsdzk.utils

enum EArchivioSorgenteSoggetto {

    ANA, CIV, ANP

    Map getEtichettaDesc() {
        switch (this) {
            case ANA: return Etichette.Anagrafe
            case CIV: return Etichette.Stato_Civile
            case ANP: return Etichette.ANPR
        }
        return null
    }
}