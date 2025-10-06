package it.finmatica.de4gsdzk.errors

class NoRecordFoundRuntimeException extends De4gsdzkRuntimeException {

    NoRecordFoundRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}
