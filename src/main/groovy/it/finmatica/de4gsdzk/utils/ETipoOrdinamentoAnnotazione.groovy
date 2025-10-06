package it.finmatica.de4gsdzk.utils

enum ETipoOrdinamentoAnnotazione {

    Nuovo_Ordinamento, Vecchio_Ordinamento, Tutte

    Map getEtichettaDesc(){
        String methodName = this.name()
        return Etichette."$methodName"
    }

}