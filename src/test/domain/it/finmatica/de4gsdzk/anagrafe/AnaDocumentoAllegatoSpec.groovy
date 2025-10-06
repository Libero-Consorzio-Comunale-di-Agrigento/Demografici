package it.finmatica.de4gsdzk.anagrafe

import spock.lang.Specification

class AnaDocumentoAllegatoSpec extends Specification {

    void "Oggetto AnaDocumentoAllegato ha abilitato il download dell'allegato"() {
        given:
        AnaDocumentoAllegato allegato = new AnaDocumentoAllegato()
        allegato.idFileEsterno = idFileEsterno
        allegato.blobAllegato = blobAllegato

        expect:
        allegato.canDownload() == expected

        where:
        idFileEsterno | blobAllegato | expected
        null          | null         | false
        1             | null         | true
        null          | new byte[1]  | true
    }
}
