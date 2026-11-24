package it.finmatica.de4gsdzk.utils

enum EFiltroCognome {

    A_L('A'),
    M_Z('M')

    final String id

    private EFiltroCognome(String id) {
        this.id = id
    }


    Map getEtichettaDesc(){
        switch(this) {
            case A_L: return Etichette.getEtichetta("A_L")
            case M_Z: return Etichette.getEtichetta("M_Z")
        }
        return null
    }

}