package it.finmatica.de4gsdzk.errors

class AnscClientUnmanagedStatusException extends De4gsdzkRuntimeException {
    Integer statusCode

    AnscClientUnmanagedStatusException(Integer statusCode) {
        super("Status code ${statusCode}")
        this.statusCode = statusCode
    }
}
