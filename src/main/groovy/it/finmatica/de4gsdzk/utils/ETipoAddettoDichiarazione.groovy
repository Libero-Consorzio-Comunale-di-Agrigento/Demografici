package it.finmatica.de4gsdzk.utils

enum ETipoAddettoDichiarazione {

    AD("AD"), // "Addetto_Delegato"
    DS("DS")  // "Direttore_Sanitario"

    final String id

    private ETipoAddettoDichiarazione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case AD: return Etichette.Addetto_Delegato
            case DS: return Etichette.Direttore_Sanitario
        }
        return null
    }

}