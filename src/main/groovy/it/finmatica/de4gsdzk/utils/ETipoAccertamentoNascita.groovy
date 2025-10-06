package it.finmatica.de4gsdzk.utils

enum ETipoAccertamentoNascita {

    //ANSC_78
    AN("AN"), // attestazione di nascita
    CP("CP"), // constatazione parto
    DS("DS")  // dichiarazione sostitutiva

    final String id

    private ETipoAccertamentoNascita(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case AN: return Etichette.attestazione_nascita
            case CP: return Etichette.constatazione_parto
            case DS: return Etichette.dichiarazione_sostitutiva
        }
        return null
    }

}