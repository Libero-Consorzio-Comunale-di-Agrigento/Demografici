package it.finmatica.de4gsdzk.utils

enum ETipoDocumento {

    Entrata, Uscita

    public boolean isUscita(){
        return (this == Uscita)
    }

    public boolean isEntrata(){
        return (this == Entrata)
    }

    Map getEtichettaDesc(){
        String methodName = this.name()
        return Etichette.getEtichetta(methodName)
    }

}