package it.finmatica.de4gsdzk.certificazione.error

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class UtenteNonTerminalistaRuntimeException extends De4gsdzkRuntimeException {
    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Errore_Utente_non_terminalista

    UtenteNonTerminalistaRuntimeException() {
        this('')
    }

    UtenteNonTerminalistaRuntimeException(String additionalInfo) {
        super(etichettaDefault, additionalInfo, (etichettaDefault.defaultValue + " " + (additionalInfo ?: "")))
    }
}
