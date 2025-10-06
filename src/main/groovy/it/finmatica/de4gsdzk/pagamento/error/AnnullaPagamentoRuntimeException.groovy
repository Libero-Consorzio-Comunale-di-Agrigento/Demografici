package it.finmatica.de4gsdzk.pagamento.error

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class AnnullaPagamentoRuntimeException extends De4gsdzkRuntimeException {
    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Errore_Annulla_pagamento

    AnnullaPagamentoRuntimeException(String additionalInfo) {
        super(etichettaDefault, additionalInfo, (etichettaDefault.defaultValue + "\n" + (additionalInfo ?: "")))
    }
}
