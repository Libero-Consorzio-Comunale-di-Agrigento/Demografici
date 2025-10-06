package it.finmatica.de4gsdzk.utils

enum ETipoDocumentoFineOpposizione {

    DE("DE"), // "decreto rigetto"
    PR("PR")  // "provvedimento estinzione"

    final String id

    private ETipoDocumentoFineOpposizione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case DE: return Etichette.decreto_rigetto
            case PR: return Etichette.provvedimento_estinzione
        }
        return null
    }

}