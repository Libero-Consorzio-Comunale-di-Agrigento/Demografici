package it.finmatica.de4gsdzk.certificazione.generazione.anpr

import it.finmatica.de4gsdzk.certificazione.generazione.GenerazioneCertificatoRuntimeExceptionBase
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class AnprGenerazioneCertificatoRuntimeException extends GenerazioneCertificatoRuntimeExceptionBase {

    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Errore_ANPR_generazione_cer

    AnprGenerazioneCertificatoRuntimeException(Throwable cause) {
        super(etichettaDefault, cause)
    }
}