package it.finmatica.de4gsdzk.competenze

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException

class CompetenzeRuntimeException extends De4gsdzkRuntimeException {

    CompetenzeRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}