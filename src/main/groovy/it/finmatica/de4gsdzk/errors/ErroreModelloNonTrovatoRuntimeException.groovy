package it.finmatica.de4gsdzk.errors

import it.finmatica.de4gsdzk.utils.Etichette


class ErroreModelloNonTrovatoRuntimeException extends De4gsdzkRuntimeException {

    private static final Map<String, String> etichettaDefault = Etichette.getEtichetta("Errore_modello_testo_non_trovato")

    ErroreModelloNonTrovatoRuntimeException() {
        super(etichettaDefault, (String) etichettaDefault?.defaultValue)
    }

    ErroreModelloNonTrovatoRuntimeException(String additionalInfo) {
        super(etichettaDefault, additionalInfo, (etichettaDefault.defaultValue + " " + (additionalInfo?:"")))
    }

    ErroreModelloNonTrovatoRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

    ErroreModelloNonTrovatoRuntimeException(Map<String, String> etichetta, String additionalInfo) {
        super(etichetta, additionalInfo, (etichetta?.defaultValue + " " + (additionalInfo?:"")))
    }

}