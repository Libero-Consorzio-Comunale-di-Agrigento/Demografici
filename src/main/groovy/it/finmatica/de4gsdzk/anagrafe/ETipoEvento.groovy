package it.finmatica.de4gsdzk.anagrafe

enum ETipoEvento {
    ISCRIZIONE("I"),
    CANCELLAZIONE("C"),
    CAMBIO_ABITAZIONE("E")

    final String id

    ETipoEvento(String id) {
        this.id = id
    }

    static ETipoEvento valueOfId(String id) {
        ETipoEvento result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }
}