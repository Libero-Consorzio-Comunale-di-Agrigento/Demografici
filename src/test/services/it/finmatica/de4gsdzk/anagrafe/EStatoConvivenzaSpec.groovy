package it.finmatica.de4gsdzk.anagrafe

import spock.lang.Specification

class EStatoConvivenzaSpec extends Specification {
    def "Dovrebbe restituire l'id corretto per ogni enum"() {
        expect:
        statoConvivenza.id == idAtteso

        where:
        statoConvivenza    | idAtteso
        EStatoConvivenza.ANNULLATA | 'A'
        EStatoConvivenza.DICHIARATA | 'D'
        EStatoConvivenza.CESSATA | 'F'
        EStatoConvivenza.ATTIVA | 'I'
    }

    def "Dovrebbe restituire l'enum corretto per ogni id"() {
        expect:
        EStatoConvivenza.valueOfId(id) == statoConvivenza

        where:
        id  | statoConvivenza
        'A' | EStatoConvivenza.ANNULLATA
        'D' | EStatoConvivenza.DICHIARATA
        'F' | EStatoConvivenza.CESSATA
        'I' | EStatoConvivenza.ATTIVA
    }

    def "Dovrebbe lanciare IllegalArgumentException per un id non valido"() {
        when:
        EStatoConvivenza.valueOfId('INVALIDO')

        then:
        thrown(IllegalArgumentException)
    }
}
