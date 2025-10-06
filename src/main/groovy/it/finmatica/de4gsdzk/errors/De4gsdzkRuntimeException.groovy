package it.finmatica.de4gsdzk.errors

class De4gsdzkRuntimeException extends RuntimeException {

    private final String additionalInfo

    private final Map<String, String> etichetta

    De4gsdzkRuntimeException() {
        super()
    }

    De4gsdzkRuntimeException(String message) {
        super(message)
    }

    De4gsdzkRuntimeException(String message, Throwable cause) {
        super(message, cause)
    }

    De4gsdzkRuntimeException(Throwable cause) {
        super(cause)
    }

    De4gsdzkRuntimeException(Map<String, String> etichetta, String msg) {
        super(msg)
        this.etichetta = etichetta
    }

    De4gsdzkRuntimeException(Map<String, String> etichetta, String additionalInfo, String msg) {
        super(msg)
        this.etichetta = etichetta
        this.additionalInfo = additionalInfo
    }

    De4gsdzkRuntimeException(Map<String, String> etichetta, String additionalInfo, String msg, Throwable cause) {
        super(msg, cause)
        this.etichetta = etichetta
        this.additionalInfo = additionalInfo
    }

    Map<String, String> getEtichetta(){
        return this.etichetta
    }

    String getAdditionalInfo() {
        return additionalInfo
    }

}
