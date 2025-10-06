package it.finmatica.de4gsdzk.anagrafe


import spock.lang.Specification
import spock.lang.Unroll

class AnaAnagrafeAllegatoSpec extends Specification {

    @Unroll
    void "AnaAnagrafeAllegato è scaricabile in base allo stato dell'allegato"() {
        given:
        AnaAnagrafeAllegato allegato = famigliaGiven

        expect:
        allegato.canDownload() == expected

        where:
        famigliaGiven                                      | expected
        new AnaAnagrafeAllegato(idFileEsterno: 1L)         | true
        new AnaAnagrafeAllegato(blobAllegato: new byte[0]) | true
        new AnaAnagrafeAllegato()                          | false
    }
}
