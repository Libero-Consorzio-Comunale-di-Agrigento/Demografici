package it.finmatica.de4gsdzk.errors

import it.finmatica.de4gsdzk.utils.Etichette


class FileNameNonAttesoRuntimeException extends De4gsdzkRuntimeException {

    private static final Map<String, String> etichettaDefault = Etichette.getEtichetta("Warn_file_modello_comunicazione")

    FileNameNonAttesoRuntimeException(String additionalInfo) {
        super(etichettaDefault, additionalInfo, (etichettaDefault?.defaultValue + " " + (additionalInfo ?: "")))
    }

}
