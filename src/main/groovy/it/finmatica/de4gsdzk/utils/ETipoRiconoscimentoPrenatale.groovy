package it.finmatica.de4gsdzk.utils

enum ETipoRiconoscimentoPrenatale {

    MD("MD"),       // Materno
    PD("PD"),       // Entrambi (atto unico)
    PDMD("PDMD")    // Entrambi (atti diversi)

    final String id

    private ETipoRiconoscimentoPrenatale(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case MD: return Etichette.Materno
            case PD: return Etichette.Entrambi_riconoscimento_unico
            case PDMD: return Etichette.Entrambi_riconoscimento_diverso
        }
        return null
    }

}