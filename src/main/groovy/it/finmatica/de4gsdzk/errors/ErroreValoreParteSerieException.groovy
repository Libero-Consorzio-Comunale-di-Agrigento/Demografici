package it.finmatica.de4gsdzk.errors

class ErroreValoreParteSerieException extends De4gsdzkRuntimeException {

    ErroreValoreParteSerieException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

    ErroreValoreParteSerieException(Map<String, String> etichetta, String additionalInfo) {
        super(etichetta, additionalInfo, (etichetta?.defaultValue + " " + (additionalInfo?:"")))
    }

}
