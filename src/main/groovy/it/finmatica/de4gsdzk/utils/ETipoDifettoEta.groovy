package it.finmatica.de4gsdzk.utils

enum ETipoDifettoEta {

    // ANSC_47
    D1("D1"), // Nessun difetto d'età
    D2("D2"), // Difetto d'età dello sposo
    D3("D3"), // Difetto d'età dello sposa
    D4("D4")  // Dietto d'età di entrambi

    final String id

    private ETipoDifettoEta(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case D1: return Etichette.getEtichetta("Nessun_difetto")
            case D2: return Etichette.getEtichetta("Difetto_sposo")
            case D3: return Etichette.getEtichetta("Difetto_sposa")
            case D4: return Etichette.getEtichetta("Difetto_entrambi")
        }
        return null
    }

}