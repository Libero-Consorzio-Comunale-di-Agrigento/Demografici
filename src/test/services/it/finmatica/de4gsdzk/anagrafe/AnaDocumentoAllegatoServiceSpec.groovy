package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.anagrafe.errors.NomeAllegatoEsistenteRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import spock.lang.Specification

class AnaDocumentoAllegatoServiceSpec extends Specification {
    AnaDocumentoAllegatoService service

    void setup() {
        service = new AnaDocumentoAllegatoService(Mock(AnaDocumentoAllegatoRepository), Mock(AnaDocumentoRepository), Mock(GsdFirmaService), Mock(IntegrazioneDocumentaleService), Mock(StatoCivileService))
    }

    void "Creazione allegato"() {
        given:
        AnaDocumento documento = new AnaDocumento()
        documento.allegati = [new AnaDocumentoAllegato(nome: "nomefile1"), new AnaDocumentoAllegato(nome: "nomefile2")]

        when:
        AnaDocumentoAllegato allegato = service.create(documento, "nomefile3")

        then:
        allegato.documento == documento
        allegato.nome == "nomefile3"
        documento.allegati.size() == 3
        documento.allegati.contains(allegato)
    }

    void "Creazione allegato con documento senza allegati"() {
        given:
        AnaDocumento documento = new AnaDocumento()

        when:
        AnaDocumentoAllegato allegato = service.create(documento, "nomefile3")

        then:
        allegato.documento == documento
        allegato.nome == "nomefile3"
        documento.allegati.size() == 1
        documento.allegati.contains(allegato)
    }

    void "Creazione allegato genera eccezione se nomefile duplicato"() {
        given:
        AnaDocumento documento = new AnaDocumento()
        documento.allegati = [new AnaDocumentoAllegato(nome: "nomefile1"), new AnaDocumentoAllegato(nome: "nomefile2")]

        when:
        service.create(documento, "nomefile2")

        then:
        thrown(NomeAllegatoEsistenteRuntimeException)
    }
}
