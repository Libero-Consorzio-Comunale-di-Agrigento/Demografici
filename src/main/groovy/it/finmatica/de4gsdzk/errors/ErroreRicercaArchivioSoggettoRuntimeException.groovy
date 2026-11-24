package it.finmatica.de4gsdzk.errors

import it.finmatica.de4gsdzk.utils.Etichette


class ErroreRicercaArchivioSoggettoRuntimeException extends De4gsdzkRuntimeException {

    private static final Map<String, String> etichettaDefault = Etichette.getEtichetta("Errore_Ricerca_Archivio_Soggetto")

    ErroreRicercaArchivioSoggettoRuntimeException() {
        super(etichettaDefault, (String) etichettaDefault?.defaultValue)
    }
}