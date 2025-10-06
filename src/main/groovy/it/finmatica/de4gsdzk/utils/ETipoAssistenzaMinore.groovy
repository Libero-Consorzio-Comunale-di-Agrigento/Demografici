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
            case PD: return Etichette.Padre
            case MD: return Etichette.Madre
            case PDMD: return Etichette.Entrambi_genitori
            case TU: return Etichette.Tutore
            case PS: return Etichette.Procuratore_speciale
        }
        return null
    }

}