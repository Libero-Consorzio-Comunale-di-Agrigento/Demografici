package it.finmatica.de4gsdzk.utils

enum EArchivioSorgenteSoggetto {

    ANA, CIV, ANP

    Map getEtichettaDesc() {
        switch (this) {
            case ANA: return Etichette.getEtichetta("Anagrafe")
            case CIV: return Etichette.getEtichetta("Stato_Civile")
            case ANP: return Etichette.getEtichetta("ANPR")
        }
        return null
    }
}