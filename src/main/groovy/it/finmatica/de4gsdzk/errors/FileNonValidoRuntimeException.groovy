package it.finmatica.de4gsdzk.errors

class FileNonValidoRuntimeException extends De4gsdzkRuntimeException {

   FileNonValidoRuntimeException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

    FileNonValidoRuntimeException(Map<String, String> etichetta, String additionalInfo) {
        super(etichetta, additionalInfo, (etichetta?.defaultValue + " " + (additionalInfo?:"")))
    }

}
