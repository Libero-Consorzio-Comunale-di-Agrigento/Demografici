package it.finmatica.de4gsdzk.errors

class ErroreDatiFascicoloRuntimeException extends De4gsdzkRuntimeException {

    ErroreDatiFascicoloRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}
