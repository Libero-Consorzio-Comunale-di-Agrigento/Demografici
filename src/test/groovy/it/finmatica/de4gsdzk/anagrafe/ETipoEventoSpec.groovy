package it.finmatica.de4gsdzk.anagrafe

import spock.lang.Specification

class ETipoEventoSpec extends Specification {

    def "Dovrebbe restituire l'id corretto per ogni enum"() {
        expect:
        tipoEvento.id == idAtteso

        where:
        tipoEvento | idAtteso
        ETipoEvento.ISCRIZIONE        | 'I'
        ETipoEvento.CANCELLAZIONE     | 'C'
        ETipoEvento.CAMBIO_ABITAZIONE | 'E'
    }

    def "Dovrebbe restituire l'enum corretto per ogni id"() {
        expect:
        ETipoEvento.valueOfId(id) == tipoAnagrafeAtteso

        where:
        id  | tipoAnagrafeAtteso
        'I' | ETipoEvento.ISCRIZIONE
        'C' | ETipoEvento.CANCELLAZIONE
        'E' | ETipoEvento.CAMBIO_ABITAZIONE
    }

    def "Dovrebbe lanciare IllegalArgumentException per un id non valido"() {
        when:
        ETipoEvento.valueOfId('INVALIDO')

        then:
        thrown(IllegalArgumentException)
    }
}
