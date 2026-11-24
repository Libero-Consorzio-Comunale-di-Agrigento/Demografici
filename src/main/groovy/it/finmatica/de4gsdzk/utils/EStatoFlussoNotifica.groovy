package it.finmatica.de4gsdzk.utils

enum EStatoFlussoNotifica {

    // ANSC_102
    DA("DA", 1), // Da approvare
    AP("AP", 2), // Approvata
    RI("RI", 3), // Rifiutata
    SI("SI", 4), // Stato Informativo

    final String id
    final int valore

    private EStatoFlussoNotifica(String id, int valore) {
        this.id = id
        this.valore = valore
    }

    Map getEtichettaDesc(){
        switch(this) {
            case DA: return Etichette.getEtichetta("Da_approvare")
            case AP: return Etichette.getEtichetta("Approvata")
            case RI: return Etichette.getEtichetta("Rifiutata")
            case SI: return Etichette.getEtichetta("Informativa")
        }
        return null
    }

}