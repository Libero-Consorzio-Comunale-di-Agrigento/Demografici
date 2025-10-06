package it.finmatica.de4gsdzk.errors

import it.finmatica.de4gsdzk.ansc.AnscCodificaErrore

class AnscRuntimeException extends De4gsdzkRuntimeException {

    private AnscCodificaErrore codificaErrore

    AnscRuntimeException(String message) {
        super(message)
    }

    AnscRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

    AnscRuntimeException(AnscCodificaErrore codificaErrore) {
        super(codificaErrore.descrizione)
        this.codificaErrore = codificaErrore
    }

    AnscCodificaErrore getCodificaErrore() {
        return codificaErrore
    }
}