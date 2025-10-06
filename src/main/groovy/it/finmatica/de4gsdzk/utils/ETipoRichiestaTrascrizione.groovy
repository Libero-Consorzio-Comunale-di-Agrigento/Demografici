package it.finmatica.de4gsdzk.utils

enum ETipoRichiestaTrascrizione {

    CS("CS"), // Comunicazione scritta
    CV("CV")  // Comunicazione verbale

    final String id

    private ETipoRichiestaTrascrizione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case CS: return Etichette.Comunicazione_scritta
            case CV: return Etichette.Verbale
        }
        return null
    }

}