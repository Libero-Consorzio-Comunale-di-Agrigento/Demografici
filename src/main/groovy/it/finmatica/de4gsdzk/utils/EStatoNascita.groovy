package it.finmatica.de4gsdzk.utils

enum EStatoNascita {

    Nato_vivo,  //NULL
    Nato_morto, //SI
    Vivo_morto  //NO

    Map getEtichettaDesc(){
        String methodName = this.name()
        return Etichette."$methodName"
    }

}