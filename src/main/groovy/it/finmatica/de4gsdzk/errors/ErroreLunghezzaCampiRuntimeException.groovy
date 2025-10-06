package it.finmatica.de4gsdzk.errors

import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class ErroreLunghezzaCampiRuntimeException extends De4gsdzkRuntimeException {

    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Errore_Lunghezza_Campo

    ErroreLunghezzaCampiRuntimeException(String additionalInfo) {
        super(etichettaDefault, additionalInfo, (etichettaDefault.defaultValue + " " + (additionalInfo?:"")) )
    }

}
