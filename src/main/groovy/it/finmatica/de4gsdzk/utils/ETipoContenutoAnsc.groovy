package it.finmatica.de4gsdzk.utils

enum ETipoContenutoAnsc {

    // ANSC_2
    // 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO / 5 - RIFIUTO
    ATTO("ATTO", 1),
    ANNOTAZIONE("ANNOTAZIONE", 2),
    TRASCRIZIONE("TRASCRIZIONE", 3),
    ANNOTAZIONE_AUTO("ANNOTAZIONE_AUTO", 4),
    RIFIUTO("RIFIUTO", 5),

    final String id
    final Integer valore

    private ETipoContenutoAnsc(String id, Integer valore) {
        this.id = id
        this.valore = valore
    }

    Map getEtichettaDesc(){
        switch(this) {
            case ATTO: return Etichette.getEtichetta("Atto")
            case ANNOTAZIONE: return Etichette.getEtichetta("Annotazione")
            case TRASCRIZIONE: return Etichette.getEtichetta("Trascrizione")
            case ANNOTAZIONE_AUTO: return Etichette.getEtichetta("Annotazione_auto")
            case RIFIUTO: return Etichette.getEtichetta("Rifiuto")
        }
        return null
    }

}