package it.finmatica.de4gsdzk.utils

enum ETipoComunicazioneAnagrafe {

    C("C"), // Comunicazioni
    P("P")  // Pratica

    final String id

    private ETipoComunicazioneAnagrafe(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case C: return Etichette.getEtichetta("Comunicazioni")
            case P: return Etichette.getEtichetta("Adempimenti_Pratica")
        }
        return null
    }

}
