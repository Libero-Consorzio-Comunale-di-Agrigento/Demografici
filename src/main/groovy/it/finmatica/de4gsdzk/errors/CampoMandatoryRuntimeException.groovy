package it.finmatica.de4gsdzk.errors


import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class CampoMandatoryRuntimeException extends De4gsdzkRuntimeException {

    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Compilare_campi_obbligatori

    CampoMandatoryRuntimeException() {
        super(etichettaDefault, (String) etichettaDefault?.defaultValue)
    }

    CampoMandatoryRuntimeException(String additionalInfo) {
        super(etichettaDefault, additionalInfo, (etichettaDefault.defaultValue + " " + (additionalInfo?:"")))
    }

    CampoMandatoryRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

    CampoMandatoryRuntimeException(Map<String, String> etichetta, String additionalInfo) {
        super(etichetta, additionalInfo, (etichetta?.defaultValue + " " + (additionalInfo?:"")))
    }

}