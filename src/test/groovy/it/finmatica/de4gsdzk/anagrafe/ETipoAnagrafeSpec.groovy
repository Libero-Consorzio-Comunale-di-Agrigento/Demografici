package it.finmatica.de4gsdzk.anagrafe

import spock.lang.Specification

class ETipoAnagrafeSpec extends Specification {

    def "Dovrebbe restituire l'id corretto per ogni enum"() {
        expect:
        tipoAnagrafe.id == idAtteso

        where:
        tipoAnagrafe                | idAtteso
        ETipoAnagrafe.RESIDENTI     | 'RES'
        ETipoAnagrafe.NON_RESIDENTI | 'NRE'
        ETipoAnagrafe.AIRE          | 'AIR'
    }

    def "Dovrebbe restituire l'enum corretto per ogni id"() {
        expect:
        ETipoAnagrafe.valueOfId(id) == tipoAnagrafeAtteso

        where:
        id    | tipoAnagrafeAtteso
        'RES' | ETipoAnagrafe.RESIDENTI
        'NRE' | ETipoAnagrafe.NON_RESIDENTI
        'AIR' | ETipoAnagrafe.AIRE
    }

    def "Dovrebbe lanciare IllegalArgumentException per un id non valido"() {
        when:
        ETipoAnagrafe.valueOfId('INVALIDO')

        then:
        thrown(IllegalArgumentException)
    }
}
