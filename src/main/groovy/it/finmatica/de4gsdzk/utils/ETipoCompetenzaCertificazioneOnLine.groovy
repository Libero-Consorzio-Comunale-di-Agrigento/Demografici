package it.finmatica.de4gsdzk.utils

enum ETipoCompetenzaCertificazioneOnLine {

    AN("AN"), // Anagrafe
    SC("SC"), // Stato Civile

    final String id

    private ETipoCompetenzaCertificazioneOnLine(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case AN: return Etichette.getEtichetta("Anagrafe")
            case SC: return Etichette.getEtichetta("Stato_Civile")
        }
        return null
    }

}