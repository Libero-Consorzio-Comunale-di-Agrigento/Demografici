package it.finmatica.de4gsdzk.errors

class EmptyReportException extends De4gsdzkRuntimeException {

    EmptyReportException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}
