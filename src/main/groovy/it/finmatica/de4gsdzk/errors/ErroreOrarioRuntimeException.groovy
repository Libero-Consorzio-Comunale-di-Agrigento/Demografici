package it.finmatica.de4gsdzk.errors

class ErroreOrarioRuntimeException extends De4gsdzkRuntimeException {

    ErroreOrarioRuntimeException(Map<String, String> etichetta, String additionalInfo) {
        super(etichetta, additionalInfo, (etichetta?.defaultValue + " " + (additionalInfo?:"")))
    }

}
