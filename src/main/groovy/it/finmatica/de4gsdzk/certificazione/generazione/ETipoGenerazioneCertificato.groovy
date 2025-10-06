package it.finmatica.de4gsdzk.certificazione.generazione

import it.finmatica.de4gsdzk.utils.Etichette

enum ETipoGenerazioneCertificato {
    GTE,
    ANSC,
    ANPR

    Boolean isGenerazioneEsterna() {
        return this == ANSC || this == ANPR
    }

    Map getEtichettaDesc() {
        switch (this) {
            case GTE: return Etichette.Gestione_Testi
            case ANSC: return Etichette.ANSC
            case ANPR: return Etichette.ANPR
        }
        return null
    }

}