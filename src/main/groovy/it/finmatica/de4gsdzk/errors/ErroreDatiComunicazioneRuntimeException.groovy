package it.finmatica.de4gsdzk.errors

class ErroreDatiComunicazioneRuntimeException extends De4gsdzkRuntimeException {

    ErroreDatiComunicazioneRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}
