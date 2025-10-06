package it.finmatica.de4gsdzk.pagamento.error

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class SincronizzazioneErroreException extends De4gsdzkRuntimeException {
    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Errore_Sincronizzazione_errore

    SincronizzazioneErroreException() {
        super(etichettaDefault, (String) etichettaDefault?.defaultValue)
    }
}
