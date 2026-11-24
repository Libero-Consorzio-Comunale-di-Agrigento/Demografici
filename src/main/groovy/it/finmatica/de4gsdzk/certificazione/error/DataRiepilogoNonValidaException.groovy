package it.finmatica.de4gsdzk.certificazione.error

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette

class DataRiepilogoNonValidaException extends De4gsdzkRuntimeException {

    private static final Map<String, String> etichettaDefault = Etichette.getEtichetta("Warn_Data_Riepilogo_Non_Valida")

    DataRiepilogoNonValidaException() {
        this('')
    }

    DataRiepilogoNonValidaException(String additionalInfo) {
        super(etichettaDefault, additionalInfo, (etichettaDefault.defaultValue + " " + (additionalInfo ?: "")))
    }
}
