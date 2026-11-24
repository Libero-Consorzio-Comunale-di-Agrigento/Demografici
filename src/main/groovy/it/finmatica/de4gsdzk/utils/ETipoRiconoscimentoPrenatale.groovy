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
            case MD: return Etichette.getEtichetta("Materno")
            case PD: return Etichette.getEtichetta("Entrambi_riconoscimento_unico")
            case PDMD: return Etichette.getEtichetta("Entrambi_riconoscimento_diverso")
        }
        return null
    }

}