package it.finmatica.de4gsdzk.certificazione.error

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException

class FirmatariListRuntimeException extends De4gsdzkRuntimeException {
    FirmatariListRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }
}
