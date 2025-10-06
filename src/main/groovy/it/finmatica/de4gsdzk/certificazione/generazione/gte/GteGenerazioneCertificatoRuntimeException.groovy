package it.finmatica.de4gsdzk.certificazione.generazione.gte

import it.finmatica.de4gsdzk.certificazione.generazione.GenerazioneCertificatoRuntimeExceptionBase
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class GteGenerazioneCertificatoRuntimeException extends GenerazioneCertificatoRuntimeExceptionBase {

    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Errore_GTE_generazione_cer


    GteGenerazioneCertificatoRuntimeException(Throwable cause) {
        super(etichettaDefault, cause)
    }
}