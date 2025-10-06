package it.finmatica.de4gsdzk.utils

enum EQualifica {

    ME("ME"), // Medico
    OS("OS"), // Ostetrica
    AL("AL")  // Altro

    final String id

    private EQualifica(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case ME: return Etichette.Medico
            case OS: return Etichette.Ostetrica
            case AL: return Etichette.Altro
        }
        return null
    }

}
