package it.finmatica.de4gsdzk.certificazione.generazione.ansc

import it.finmatica.de4gsdzk.certificazione.generazione.GenerazioneCertificatoRuntimeExceptionBase
import it.finmatica.de4gsdzk.utils.Etichette

class AnscGenerazioneCertificatoRuntimeException extends GenerazioneCertificatoRuntimeExceptionBase {

    private static final Map<String, String> etichettaDefault = Etichette.getEtichetta("Errore_ANSC_generazione_cer")


    AnscGenerazioneCertificatoRuntimeException(Throwable cause) {
        super(etichettaDefault, cause)
    }

    AnscGenerazioneCertificatoRuntimeException(String generationError) {
        super(etichettaDefault, generationError)
    }
}