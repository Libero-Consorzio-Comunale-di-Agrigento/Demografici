package it.finmatica.de4gsdzk.errors

import it.finmatica.de4gsdzk.utils.Etichette


class TooManyRecordsFoundRuntimeException extends De4gsdzkRuntimeException {

    private static final Map etichettaDefault = Etichette.getEtichetta("Errore_Ricerca_ANPR")

    TooManyRecordsFoundRuntimeException() {
        super(etichettaDefault, (String) etichettaDefault?.defaultValue)
    }

}
