package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.anagrafe.errors.NomeAllegatoEsistenteRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.GsdService
import spock.lang.Specification

class AnaFamigliaAllegatoServiceSpec extends Specification {
    AnaFamigliaAllegatoService service

    void setup() {
        service = new AnaFamigliaAllegatoService(Mock(AnaFamigliaAllegatoRepository), Mock(AnaFamigliaRepository), Mock(GsdFirmaService), Mock(IntegrazioneDocumentaleService), Mock(GsdService))
    }

    void "Creazione allegato"() {
        given:
        AnaFamiglia famiglia = new AnaFamiglia()
        famiglia.allegati = [new AnaFamigliaAllegato(nome: "nomefile1"), new AnaFamigliaAllegato(nome: "nomefile2")]

        when:
        AnaFamigliaAllegato allegato = service.create(famiglia, "nomefile3")

        then:
        allegato.famiglia == famiglia
        allegato.nome == "nomefile3"
        famiglia.allegati.size() == 3
        famiglia.allegati.contains(allegato)
    }

    void "Creazione allegato con famiglia senza allegati"() {
        given:
        AnaFamiglia famiglia = new AnaFamiglia()

        when:
        AnaFamigliaAllegato allegato = service.create(famiglia, "nomefile3")

        then:
        allegato.famiglia == famiglia
        allegato.nome == "nomefile3"
        famiglia.allegati.size() == 1
        famiglia.allegati.contains(allegato)
    }

    void "Creazione allegato genera eccezione se nomefile duplicato"() {
        given:
        AnaFamiglia famiglia = new AnaFamiglia()
        famiglia.allegati = [new AnaFamigliaAllegato(nome: "nomefile1"), new AnaFamigliaAllegato(nome: "nomefile2")]

        when:
        service.create(famiglia, "nomefile2")

        then:
        thrown(NomeAllegatoEsistenteRuntimeException)
    }
}
