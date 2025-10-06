package it.finmatica.de4gsdzk.utils

enum ETipoSceltaCognome {

    // ANSC_39
    MP("MP"),
    AG("AG"),
    PC("PC"),
    SC("SC"),
    MC("MC"),
    MN("MN"),
    ME("ME"),
    AC("AC"),
    AN("AN"),
    PS("PS"),
    PA("PA")

    final String id

    private ETipoSceltaCognome(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case MP: return Etichette.mantenere_cognome_precedente
            case AG: return Etichette.aggiungere_al_cognome
            case PC: return Etichette.anteporre_al_cognome
            case SC: return Etichette.sostituire_cognome
            case MC: return Etichette.modifica_cognome
            case MN: return Etichette.modifica_nome
            case ME: return Etichette.modifica_nome_cognome
            case AC: return Etichette.aggiunta_al_cognome
            case AN: return Etichette.aggiunta_al_nome
            case PS: return Etichette.padre_sostituzione
            case PA: return Etichette.padre_aggiunta
        }
        return null
    }

}