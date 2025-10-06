package it.finmatica.de4gsdzk.anagrafe

enum ECodiceMovimento {
    ISCRIZIONE_APR(1),
    ISCRIZIONE_AIRE(3),

    CANCELLAZIONE_APR(2),
    CANCELLAZIONE_AIRE(4),

    ISCRIZIONE_IN_ATTESA_O_ANNULLATA(5),

    NON_RESIDENTE(6),

    VARIAZIONE_PARENTELA(10),
    VARIAZIONE_PARENTELA_AIRE(12),

    TRASFERIMENTO_RESIDENZA(11),
    TRASFERIMENTO_RESIDENZA_AIRE(13),

    RETTIFICA(97),
    RETTIFICA_AIRE(98)

    final Integer id

    ECodiceMovimento(Integer id) {
        this.id = id
    }

    static ECodiceMovimento valueOfId(Integer id) {
        ECodiceMovimento result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }
}