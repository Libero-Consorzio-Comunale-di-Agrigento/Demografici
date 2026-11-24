package it.finmatica.de4gsdzk.utils

enum ENaturaDocumento {

    O("O"), // Originale
    D("D"), // Duplicato
    A("A"), // Annullato

    final String id

    private ENaturaDocumento(String id) {
        this.id = id
    }

    Map getEtichettaDesc() {
        switch (this) {
            case O: return Etichette.getEtichetta("Originale")
            case D: return Etichette.getEtichetta("Duplicato")
            case A: return Etichette.getEtichetta("Annullato")
        }
        return null
    }

}