package it.finmatica.de4gsdzk.anagrafe.errors

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class NomeAllegatoEsistenteRuntimeException extends De4gsdzkRuntimeException {
    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Errore_nome_allegato_esistente

    NomeAllegatoEsistenteRuntimeException() {
        super(etichettaDefault, etichettaDefault.defaultValue)
    }
}
