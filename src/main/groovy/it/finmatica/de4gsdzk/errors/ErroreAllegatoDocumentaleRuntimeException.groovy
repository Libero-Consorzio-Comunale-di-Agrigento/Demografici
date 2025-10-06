package it.finmatica.de4gsdzk.errors

class ErroreAllegatoDocumentaleRuntimeException extends De4gsdzkRuntimeException {

    ErroreAllegatoDocumentaleRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}
