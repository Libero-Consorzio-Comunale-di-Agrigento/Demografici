package it.finmatica.de4gsdzk.pagamento.error

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette

class VerificaPagamentoRuntimeException extends De4gsdzkRuntimeException {
    private static final Map<String, String> etichettaDefault = Etichette.getEtichetta("Errore_Verifica_pagamento")

    VerificaPagamentoRuntimeException(String additionalInfo) {
        super(etichettaDefault, additionalInfo, (etichettaDefault.defaultValue + "\n" + (additionalInfo ?: "")))
    }
}
