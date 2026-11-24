package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

enum EGruppoTitoloStudio {

    AN("AN"),  // Analfabeta
    TE("TE"),  // Terza Elementare
    LE("LE"),  // Licenza Elementare
    LM("LM"),  // Licenza Media
    DP("DP"),  // Diploma
    LR("LR")   // Laurea

    final String id

    private EGruppoTitoloStudio(String id) {
        this.id = id
    }

    Map getEtichettaDesc() {
        switch(this) {
            case AN: return Etichette.getEtichetta("Analfabeta")
            case TE: return Etichette.getEtichetta("Terza_Elementare")
            case LE: return Etichette.getEtichetta("Licenza_Elementare")
            case LM: return Etichette.getEtichetta("Licenza_Media")
            case DP: return Etichette.getEtichetta("Diploma")
            case LR: return Etichette.getEtichetta("Laurea")
        }
        return null
    }
}