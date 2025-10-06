package it.finmatica.de4gsdzk.errors

class ErroreCaricamentoDatiRuntimeException extends De4gsdzkRuntimeException {

    ErroreCaricamentoDatiRuntimeException(String message) {
        super(message)
    }

    ErroreCaricamentoDatiRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}
