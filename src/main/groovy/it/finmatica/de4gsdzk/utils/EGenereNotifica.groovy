package it.finmatica.de4gsdzk.utils

enum EGenereNotifica {

    // ANSC_101
    ANN("ANN", 1),
    TRA("TRA", 2),
    INF("INF", 3)

    final String id
    final Integer valore

    private EGenereNotifica(String id, Integer valore) {
        this.id = id
        this.valore = valore
    }

    Map getEtichettaDesc(){
        switch(this) {
            case ANN: return Etichette.Annotazione
            case TRA: return Etichette.Trascrizione
            case INF: return Etichette.Informativa
        }
        return null
    }

}