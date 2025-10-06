package it.finmatica.de4gsdzk.anagrafe

import spock.lang.Specification
import spock.lang.Unroll

class AnaDocumentoSpec extends Specification {

    @Unroll
    void "Oggetto AnaDocumento ha abilitato il download dell'allegato"() {
        given:
        AnaDocumento documento = new AnaDocumento()
        documento.idDocumentoEsterno = idDocumentoEsterno
        documento.allegati = []
        AnaDocumentoAllegato allegato1 = Mock(AnaDocumentoAllegato)
        allegato1.canDownload() >> allegato1DownloadEnabled
        documento.allegati << allegato1

        expect:
        documento.canDownload() == expected

        where:
        idDocumentoEsterno | allegato1DownloadEnabled | expected
        null               | true                     | false
        1                  | true                     | true
        null               | false                    | false
        1                  | false                    | false
    }
}
