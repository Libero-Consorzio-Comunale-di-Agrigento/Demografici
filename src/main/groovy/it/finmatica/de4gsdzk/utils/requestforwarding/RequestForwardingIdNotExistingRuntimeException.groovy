package it.finmatica.de4gsdzk.utils.requestforwarding

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class RequestForwardingIdNotExistingRuntimeException extends De4gsdzkRuntimeException {

    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Errore_Request_Id_non_esistente

    RequestForwardingIdNotExistingRuntimeException() {
        super(etichettaDefault, (String) etichettaDefault?.defaultValue)
    }
}
