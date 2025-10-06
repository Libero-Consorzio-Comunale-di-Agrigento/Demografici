package it.finmatica.de4gsdzk.errors

class RecordDuplicatoRuntimeException extends De4gsdzkRuntimeException {

    RecordDuplicatoRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}
