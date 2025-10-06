package it.finmatica.de4gsdzk.utils

enum ETipoLuogoEvento {

    NEL_COMUNE("NEL_COMUNE"),       // nel comune
    FUORI_COMUNE("FUORI_COMUNE")    // fuori comune

    final String id

    private ETipoLuogoEvento(String id) {
        this.id = id
    }

    Map getEtichettaDesc() {
        switch(this) {
            case NEL_COMUNE: return Etichette.nel_Comune
            case FUORI_COMUNE: return Etichette.fuori_Comune
        }
        return null
    }

}
