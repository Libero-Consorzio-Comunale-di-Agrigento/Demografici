package it.finmatica.de4gsdzk.errors

import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class ErroreAssenzaTipoSalvataggioAnnotazioneComuneClienteSuAttoNascita1RuntimeException extends ErroreDatiAnnotazioneRuntimeException {

    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Ask_annotazione_nascita_mancante

    ErroreAssenzaTipoSalvataggioAnnotazioneComuneClienteSuAttoNascita1RuntimeException() {
        super(etichettaDefault)
    }

}
