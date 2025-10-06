package it.finmatica.de4gsdzk.utils

enum ETipoEvento {

    Nascita, Matrimonio, Divorzio, Decesso, Unione_Civile, Scioglimento, Cittadinanza,

    Nascite, Matrimoni, Divorzi, Decessi, Unioni_Civili, Scioglimenti, Cittadinanze

    Map getEtichettaDesc(){
        String methodName = this.name()
        return Etichette."$methodName"
    }
}