package it.finmatica.de4gsdzk.anagrafe


import spock.lang.Specification
import spock.lang.Unroll

class AnaFamigliaAllegatoSpec extends Specification {

    @Unroll
    void "AnaFamigliaAllegato è scaricabile in base allo stato dell'allegato"() {
        given:
        AnaFamigliaAllegato allegato = famigliaGiven

        expect:
        allegato.canDownload() == expected

        where:
        famigliaGiven                                      | expected
        new AnaFamigliaAllegato(idFileEsterno: 1L)         | true
        new AnaFamigliaAllegato(blobAllegato: new byte[0]) | true
        new AnaFamigliaAllegato()                          | false
    }
}
