package it.finmatica.de4gsdzk.utils

enum ECanaleComunicazioneNotifica {

    // ANSC_105
    PEC("PEC", 1),
    DGT("DGT", 2)

    final String id
    final Integer valore

    private ECanaleComunicazioneNotifica(String id, Integer valore) {
        this.id = id
        this.valore = valore
    }

    Map getEtichettaDesc(){
        switch(this) {
            case PEC: return Etichette.getEtichetta("PEC")
            case DGT: return Etichette.getEtichetta("DIGITALE")
        }
        return null
    }

}