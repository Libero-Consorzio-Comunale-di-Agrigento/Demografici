package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IntegrationSpec
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.DataUtils
import org.springframework.beans.factory.annotation.Autowired

class NumeroUnicoStatoCivileServiceTest extends IntegrationSpec {
    @Autowired
    GsdService gsdService

    def "Generazione del numero unico ritorna un numero maggiore di 0"() {
        given: "L'anno corrente"
        Integer annoCorrente = DataUtils.getAnnoCorrente()

        when: "Viene chiamato il metodo getNumeroUnico per l'anno corrente"
        Long numeroUnico = gsdService.getNumeroUnico(annoCorrente)

        then: "Il numero unico restituito deve essere maggiore di 0"
        numeroUnico > 0
    }

    def "Generazione del numero unico colma il primo buco di numerazione disponibile"() {
        given: "L'anno corrente"
        Integer annoCorrente = DataUtils.getAnnoCorrente()

        and: "La lista dei buchi"
        List<Long> buchi = gsdService.listBuchiNumerazione(annoCorrente)

        if (buchi.isEmpty()) {
            // Ignora il test se non ci sono buchi
            return
        }

        when: "Viene chiamato il metodo getNumeroUnico per l'anno corrente"
        Long numeroUnico = gsdService.getNumeroUnico(annoCorrente)

        then: "Il numero unico restituito deve colmare il primo buco"
        numeroUnico == buchi.min()
    }
}
