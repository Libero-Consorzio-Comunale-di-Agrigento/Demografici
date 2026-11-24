package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.anagrafe.errors.NomeAllegatoEsistenteRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.GsdService
import spock.lang.Specification

class AnaAnagrafeAllegatoServiceSpec extends Specification {
    AnaAnagrafeAllegatoService service

    void setup() {
        service = new AnaAnagrafeAllegatoService(Mock(AnaAnagrafeAllegatoRepository), Mock(AnaAnagrafeRepository), Mock(GsdFirmaService), Mock(IntegrazioneDocumentaleService), Mock(GsdService))
    }

    void "Creazione allegato"() {
        given:
        AnaAnagrafe anagrafe = new AnaAnagrafe()
        anagrafe.allegati = [new AnaAnagrafeAllegato(nome: "nomefile1"), new AnaAnagrafeAllegato(nome: "nomefile2")]

        when:
        AnaAnagrafeAllegato allegato = service.create(anagrafe, "nomefile3")

        then:
        allegato.anagrafe == anagrafe
        allegato.nome == "nomefile3"
        anagrafe.allegati.size() == 3
        anagrafe.allegati.contains(allegato)
    }

    void "Creazione allegato con famiglia senza allegati"() {
        given:
        AnaAnagrafe anagrafe = new AnaAnagrafe()

        when:
        AnaAnagrafeAllegato allegato = service.create(anagrafe, "nomefile3")

        then:
        allegato.anagrafe == anagrafe
        allegato.nome == "nomefile3"
        anagrafe.allegati.size() == 1
        anagrafe.allegati.contains(allegato)
    }

    void "Creazione allegato genera eccezione se nomefile duplicato"() {
        given:
        AnaAnagrafe famiglia = new AnaAnagrafe()
        famiglia.allegati = [new AnaAnagrafeAllegato(nome: "nomefile1"), new AnaAnagrafeAllegato(nome: "nomefile2")]

        when:
        service.create(famiglia, "nomefile2")

        then:
        thrown(NomeAllegatoEsistenteRuntimeException)
    }
}
