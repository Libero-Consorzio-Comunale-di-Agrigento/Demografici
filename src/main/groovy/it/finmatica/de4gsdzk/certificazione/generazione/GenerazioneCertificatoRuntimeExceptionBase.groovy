package it.finmatica.de4gsdzk.certificazione.generazione

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException

abstract class GenerazioneCertificatoRuntimeExceptionBase extends De4gsdzkRuntimeException {

    String generationError

    GenerazioneCertificatoRuntimeExceptionBase(Map<String, String> etichetta, Throwable cause) {
        this(etichetta, cause.message, cause)
    }

    GenerazioneCertificatoRuntimeExceptionBase(Map<String, String> etichetta, String generationError) {
        super(etichetta, generationError, (etichetta.defaultValue + "\n" + (generationError ?: "")))
        this.generationError = generationError
    }

    GenerazioneCertificatoRuntimeExceptionBase(Map<String, String> etichetta, String generationError, Throwable cause) {
        super(etichetta, generationError, (etichetta.defaultValue + "\n" + (generationError ?: "")), cause)
        this.generationError = generationError
    }
}