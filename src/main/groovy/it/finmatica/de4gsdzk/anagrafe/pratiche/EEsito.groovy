package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.utils.Etichette

enum EEsito {

    P("P"),
    N("N")

    final String id

    private EEsito(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case P: return Etichette.getEtichetta("Positivo")
            case N: return Etichette.getEtichetta("Negativo")
        }
        return null
    }

}