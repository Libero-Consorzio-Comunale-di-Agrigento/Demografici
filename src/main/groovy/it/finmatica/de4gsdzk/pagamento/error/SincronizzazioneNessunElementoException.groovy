package it.finmatica.de4gsdzk.pagamento.error

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class SincronizzazioneNessunElementoException extends De4gsdzkRuntimeException {
    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Warn_Sincronizzazione_nessun_elemento

    SincronizzazioneNessunElementoException() {
        super(etichettaDefault, (String) etichettaDefault?.defaultValue)
    }
}
