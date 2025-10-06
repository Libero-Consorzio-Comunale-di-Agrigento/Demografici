package it.finmatica.de4gsdzk.archivi

import it.finmatica.de4gsdzk.archivi.ArcParametroRepository
import spock.lang.Specification
import spock.lang.Unroll

class ArcParametroServiceSpec extends Specification {
    private static final String ABSOLUTE_URL = 'https://x.x.x.x/stats'
    private static final String RELATIVE_URL = '/stats'
    private static final String INVALID_URL = ":://invalid-uri"

    ArcParametroRepository arcParametroRepository
    ArcParametroService arcParametroService

    void setup() {
        arcParametroRepository = Mock(ArcParametroRepository)
        arcParametroService = new ArcParametroService(arcParametroRepository)
    }

    @Unroll
    def "Dovrebbe ottenere URI non nulla e URI.toASCIIString()=#expected quando STATS_URL=#storedValue"() {
        given:
        arcParametroRepository.findById(ArcParametro.STATS_URL) >> { String id -> new ArcParametro(id: id, valore: storedValue) }

        when:
        URI uri = arcParametroService.getStatsUri()

        then:
        uri != null
        uri.toASCIIString() == expected

        where:
        storedValue  | expected
        ABSOLUTE_URL | ABSOLUTE_URL
        RELATIVE_URL | RELATIVE_URL
        INVALID_URL  | ""
    }

    @Unroll
    def "Dovrebbe ottenere URI.isAbsolute()=#absoluteness quando STATS_URL=#storedValue"() {
        given:
        arcParametroRepository.findById(ArcParametro.STATS_URL) >> { String id -> new ArcParametro(id: id, valore: storedValue) }

        when:
        URI uri = arcParametroService.getStatsUri()

        then:
        uri != null
        uri.isAbsolute() == absoluteness

        where:
        storedValue  | absoluteness
        ABSOLUTE_URL | true
        RELATIVE_URL | false
    }
}
