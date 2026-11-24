package it.finmatica.de4gsdzk.utils

enum ENaturaAtto {

    O("O"),
    T("T"),
    D("D"),
    N("N"),

    //Specifici Cittadinanza
    A("A"),
    P("P"),

    //Specifici Unione Civile
    V("V")

    final String id
    private ENaturaAtto(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case O: return Etichette.getEtichetta("Originale")
            case T: return Etichette.getEtichetta("Trascritto")
            case D: return Etichette.getEtichetta("Diverso")
            case N: return Etichette.getEtichetta("Annullato")
            case A: return Etichette.getEtichetta("Acquisto")
            case P: return Etichette.getEtichetta("Perdita")
            case V: return Etichette.getEtichetta("Processo_Verbale")
        }
        return null
    }

}