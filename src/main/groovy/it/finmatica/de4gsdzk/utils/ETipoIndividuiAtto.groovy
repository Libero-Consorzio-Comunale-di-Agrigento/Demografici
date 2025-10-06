package it.finmatica.de4gsdzk.utils

enum ETipoIndividuiAtto {

    R("R"), // Residenti
    N("N"), // Non residenti
    T("T")  // Tutti

    final String id

    private ETipoIndividuiAtto(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case R: return Etichette.Residenti
            case N: return Etichette.Non_Residenti
            case T: return Etichette.Tutti
        }
        return null
    }

}