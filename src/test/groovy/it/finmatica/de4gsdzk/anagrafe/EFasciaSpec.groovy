package it.finmatica.de4gsdzk.anagrafe

import spock.lang.Specification

class EFasciaSpec extends Specification {

    def "Dovrebbe restituire l'id corretto per ogni enum"() {
        expect:
        fascia.id == idAtteso

        where:
        fascia | idAtteso
        EFascia.ISCRITTO_APR                  | 1
        EFascia.CANCELLATO_APR                | 2
        EFascia.ISCRITTO_AIRE                 | 3
        EFascia.CANCELLATO_AIRE               | 4
        EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA | 5
        EFascia.NON_RESIDENTE                 | 6
    }

    def "Dovrebbe restituire l'enum corretto per ogni id"() {
        expect:
        EFascia.valueOfId(id) == fasciaAttesa

        where:
        id | fasciaAttesa
        1  | EFascia.ISCRITTO_APR
        2  | EFascia.CANCELLATO_APR
        3  | EFascia.ISCRITTO_AIRE
        4  | EFascia.CANCELLATO_AIRE
        5  | EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA
        6  | EFascia.NON_RESIDENTE
    }

    def "Dovrebbe lanciare IllegalArgumentException per un id non valido"() {
        when:
        EFascia.valueOfId(0)

        then:
        thrown(IllegalArgumentException)
    }
}
