package it.finmatica.de4gsdzk.utils

enum ETipoDocumentoUscita {

    Documenti_Numerati, Documenti_Non_Numerati, Documenti_Non_Associati

    Map getEtichettaDesc(){
        String methodName = this.name()
        return Etichette."$methodName"
    }

    boolean isAssociato() {
        return (this != Documenti_Non_Associati)
    }

}