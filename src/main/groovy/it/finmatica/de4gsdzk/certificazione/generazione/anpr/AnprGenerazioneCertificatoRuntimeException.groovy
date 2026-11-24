package it.finmatica.de4gsdzk.certificazione.generazione.anpr

import it.finmatica.de4gsdzk.certificazione.generazione.GenerazioneCertificatoRuntimeExceptionBase
import it.finmatica.de4gsdzk.utils.Etichette

class AnprGenerazioneCertificatoRuntimeException extends GenerazioneCertificatoRuntimeExceptionBase {

    private static final Map<String, String> etichettaDefault = Etichette.getEtichetta("Errore_ANPR_generazione_cer")

    AnprGenerazioneCertificatoRuntimeException(Throwable cause) {
        super(etichettaDefault, cause)
    }
}