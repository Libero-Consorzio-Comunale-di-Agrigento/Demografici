package it.finmatica.de4gsdzk.utils

enum ETipoProvvedimentoSeparazione {

    // ANSC_104
    PR("PR"), // Provvedimento
    NA("NA"), // Convenzione di negoziazione assistita
    AC("AC")  // Accordo che ha determinato la separazione

    final String id

    private ETipoProvvedimentoSeparazione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case PR: return Etichette.getEtichetta("Provvedimento")
            case NA: return Etichette.getEtichetta("Negoziazione_assistita")
            case AC: return Etichette.getEtichetta("Accordo_separazione")
        }
        return null
    }

}