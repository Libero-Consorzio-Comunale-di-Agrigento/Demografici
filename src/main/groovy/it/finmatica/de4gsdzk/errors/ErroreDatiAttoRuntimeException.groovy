package it.finmatica.de4gsdzk.errors

class ErroreDatiAttoRuntimeException extends De4gsdzkRuntimeException {

    ErroreDatiAttoRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

    ErroreDatiAttoRuntimeException(Map<String, String> etichetta, String additionalInfo) {
        super(etichetta, additionalInfo, (etichetta?.defaultValue + " " + (additionalInfo?:"")))
    }


}
