package it.finmatica.de4gsdzk.utils

enum ETipoSiNo {

    SI ("SI"),
    NO ("NO")

    final String id

    private ETipoSiNo(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        String methodName = this.name()
        return Etichette."$methodName"
    }

}