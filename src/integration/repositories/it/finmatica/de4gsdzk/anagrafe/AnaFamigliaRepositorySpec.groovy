package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IntegrationSpec
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import org.hibernate.Hibernate
import org.springframework.beans.factory.annotation.Autowired

@Slf4j
class AnaFamigliaRepositorySpec extends IntegrationSpec {

    @Autowired
    AnaFamigliaRepository anaFamigliaRepository

    void "Ottenimento della famiglia RES5000016 via id"() {
        given:
        String idFamiglia = "RES5000016"

        when:
        AnaFamiglia famiglia = anaFamigliaRepository.findById(idFamiglia)

        then:
        famiglia.id == idFamiglia

        famiglia.fascia != null
        famiglia.fascia instanceof EFascia
        famiglia.fascia == EFascia.ISCRITTO_APR

        famiglia.indirizzo != null
        famiglia.indirizzo instanceof IndirizzoResidenteFamiglia
        Hibernate.isInitialized((famiglia.indirizzo as IndirizzoResidenteFamiglia).indirizzo.via)
    }

}
