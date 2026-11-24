package it.finmatica.de4gsdzk.pagamento.error

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette

class SincronizzazioneNessunElementoException extends De4gsdzkRuntimeException {
    private static final Map<String, String> etichettaDefault = Etichette.getEtichetta("Warn_Sincronizzazione_nessun_elemento")

    SincronizzazioneNessunElementoException() {
        super(etichettaDefault, (String) etichettaDefault?.defaultValue)
    }
}
