package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IntegrationSpec
import it.finmatica.de4gsdzk.utils.DataUtils
import org.springframework.beans.factory.annotation.Autowired

class NumeroPagamentoTest extends IntegrationSpec {
    @Autowired
    StatoCivileService statoCivileService

    def "Generazione del numero ritorna un numero maggiore di 0"() {
        given: "L'anno corrente"
        Integer annoCorrente = DataUtils.getAnnoCorrente()

        when: "Viene chiamato il metodo getNumeroPagamento per l'anno corrente"
        Long numero = statoCivileService.getNumeroPagamento(annoCorrente)

        then: "Il numero restituito deve essere maggiore di 0"
        numero > 0
    }

}
