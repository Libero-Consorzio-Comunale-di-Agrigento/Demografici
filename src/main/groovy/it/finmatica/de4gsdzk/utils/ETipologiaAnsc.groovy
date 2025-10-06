package it.finmatica.de4gsdzk.utils

enum ETipologiaAnsc {

    // ANSC_1
    // 1 - NASCITA / 2 - MORTE / 3 - MATRIMONIO / 4 - UNIONE CIVILE / 5 - CITTADINANZA
    NASCITA("NASCITA", 1),
    MORTE("MORTE", 2),
    MATRIMONIO("MATRIMONIO", 3),
    UNIONE_CIVILE("UNIONE_CIVILE", 4),
    CITTADINANZA("CITTADINANZA", 5),

    final String id
    final Integer valore

    private ETipologiaAnsc(String id, Integer valore) {
        this.id = id
        this.valore = valore
    }

    Map getEtichettaDesc(){
        switch(this) {
            case NASCITA: return Etichette.Nascita
            case MORTE: return Etichette.Morte
            case MATRIMONIO: return Etichette.Matrimonio
            case UNIONE_CIVILE: return Etichette.Unione_Civile
            case CITTADINANZA: return Etichette.Cittadinanza
        }
        return null
    }

}