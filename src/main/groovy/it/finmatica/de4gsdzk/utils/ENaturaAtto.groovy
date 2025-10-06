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
            case O: return Etichette.Originale
            case T: return Etichette.Trascritto
            case D: return Etichette.Diverso
            case N: return Etichette.Annullato
            case A: return Etichette.Acquisto
            case P: return Etichette.Perdita
            case V: return Etichette.Processo_Verbale
        }
        return null
    }

}