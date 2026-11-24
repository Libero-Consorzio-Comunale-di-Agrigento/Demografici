package it.finmatica.de4gsdzk.utils

enum ETipoFirma {

    CEC("CEC"), // Commissione Elettorale Comunale
    UE("UE") ,// Ufficiale Elettorale
    RUE("RUE") // Responsabile Ufficio Elettorale

    String id

    ETipoFirma(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case CEC: return Etichette.getEtichetta("Commissione_Elettorale")
            case UE: return Etichette.getEtichetta("Ufficiale_Elettorale")
            case RUE: return Etichette.getEtichetta("Responsabile_Ufficio_Elettorale")
        }
        return null
    }

    String getIntestazioneFirma(){
        switch(this) {
            case CEC: return null
            case UE: return "UFFICIALE ELETTORALE"
            case RUE: return "IL RESPONSABILE DELL'UFFICIO ELETTORALE"
        }
        return null
    }

}