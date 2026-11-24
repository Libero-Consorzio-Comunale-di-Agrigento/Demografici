package it.finmatica.de4gsdzk.utils

enum ETipoAssistenzaMinore {

    // ANSC_51
    PD("PD"),       // Padre
    MD("MD"),       // Madre
    PDMD("PDMD"),   // Entrambi genitori
    TU("TU"),       // Tutore
    PS("PS")        // Procuratore speciale

    final String id

    private ETipoAssistenzaMinore(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case PD: return Etichette.getEtichetta("Padre")
            case MD: return Etichette.getEtichetta("Madre")
            case PDMD: return Etichette.getEtichetta("Entrambi_genitori")
            case TU: return Etichette.getEtichetta("Tutore")
            case PS: return Etichette.getEtichetta("Procuratore_speciale")
        }
        return null
    }

}