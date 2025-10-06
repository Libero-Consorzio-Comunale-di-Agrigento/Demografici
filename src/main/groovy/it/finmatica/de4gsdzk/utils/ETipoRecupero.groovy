package it.finmatica.de4gsdzk.utils

enum ETipoRecupero {

    Giuramento("Giuramento"),
    Dichiarazione("Dichiarazione"),
    Richiesta("Richiesta")

    final String id

    private ETipoRecupero(String id) {
        this.id = id
    }

}