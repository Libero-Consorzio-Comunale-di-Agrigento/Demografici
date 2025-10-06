package it.finmatica.de4gsdzk.errors

class ErroreDatiAnnotazioneRuntimeException extends De4gsdzkRuntimeException {

    ErroreDatiAnnotazioneRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

    ErroreDatiAnnotazioneRuntimeException(Map<String, String> etichetta, String additionalInfo) {
        super(etichetta, additionalInfo, (etichetta?.defaultValue + " " + (additionalInfo ?: "")))
    }

}
