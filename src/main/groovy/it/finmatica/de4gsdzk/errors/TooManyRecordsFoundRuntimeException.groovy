package it.finmatica.de4gsdzk.errors

import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class TooManyRecordsFoundRuntimeException extends De4gsdzkRuntimeException {

    private static final Map etichettaDefault = EtichetteMessaggi.Errore_Ricerca_ANPR

    TooManyRecordsFoundRuntimeException() {
        super(etichettaDefault, (String) etichettaDefault?.defaultValue)
    }

}
