package it.finmatica.de4gsdzk.errors

class ErroreProtocollazioneRuntimeException extends De4gsdzkRuntimeException {

    ErroreProtocollazioneRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}