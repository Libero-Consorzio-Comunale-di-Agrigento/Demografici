package it.finmatica.de4gsdzk.anagrafe

import spock.lang.Specification

class ECodiceMovimentoSpec extends Specification {

    def "Dovrebbe restituire l'id corretto per ogni enum"() {
        expect:
        elemento.id == idAtteso

        where:
        elemento | idAtteso
        ECodiceMovimento.ISCRIZIONE_APR | 1
        ECodiceMovimento.CANCELLAZIONE_APR | 2
        ECodiceMovimento.ISCRIZIONE_AIRE | 3
        ECodiceMovimento.CANCELLAZIONE_AIRE | 4
        ECodiceMovimento.ISCRIZIONE_IN_ATTESA_O_ANNULLATA | 5
        ECodiceMovimento.NON_RESIDENTE | 6
        ECodiceMovimento.VARIAZIONE_PARENTELA | 10
        ECodiceMovimento.TRASFERIMENTO_RESIDENZA | 11
        ECodiceMovimento.VARIAZIONE_PARENTELA_AIRE | 12
        ECodiceMovimento.TRASFERIMENTO_RESIDENZA_AIRE | 13
        ECodiceMovimento.RETTIFICA | 97
        ECodiceMovimento.RETTIFICA_AIRE | 98
    }

    def "Dovrebbe restituire l'enum corretto per ogni id"() {
        expect:
        ECodiceMovimento.valueOfId(id) == elementoAtteso

        where:
        id | elementoAtteso
        1  | ECodiceMovimento.ISCRIZIONE_APR
        2  | ECodiceMovimento.CANCELLAZIONE_APR
        3  | ECodiceMovimento.ISCRIZIONE_AIRE
        4  | ECodiceMovimento.CANCELLAZIONE_AIRE
        5  | ECodiceMovimento.ISCRIZIONE_IN_ATTESA_O_ANNULLATA
        6  | ECodiceMovimento.NON_RESIDENTE
        10 | ECodiceMovimento.VARIAZIONE_PARENTELA
        11 | ECodiceMovimento.TRASFERIMENTO_RESIDENZA
        12 | ECodiceMovimento.VARIAZIONE_PARENTELA_AIRE
        13 | ECodiceMovimento.TRASFERIMENTO_RESIDENZA_AIRE
        97 | ECodiceMovimento.RETTIFICA
        98 | ECodiceMovimento.RETTIFICA_AIRE
    }

    def "Dovrebbe lanciare IllegalArgumentException per un id non valido"() {
        when:
        ECodiceMovimento.valueOfId(0)

        then:
        thrown(IllegalArgumentException)
    }
}
