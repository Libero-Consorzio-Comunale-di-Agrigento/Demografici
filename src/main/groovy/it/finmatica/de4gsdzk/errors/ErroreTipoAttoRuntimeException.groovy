package it.finmatica.de4gsdzk.errors

class ErroreTipoAttoRuntimeException extends De4gsdzkRuntimeException {

    ErroreTipoAttoRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}
