package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.ICodiceMovimentoEvento
import spock.lang.Specification

class ICodiceMovimentoEventoSpec extends Specification {
    void "Oggetto CodiceMovimentoEvento rappresenta la combinazione di codiceMovimento e codiceEvento"() {
        when:
        ICodiceMovimentoEvento combinazione = new ICodiceMovimentoEvento() {
            ECodiceMovimento codiceMovimento = ECodiceMovimento.ISCRIZIONE_APR
            AnaCodiceEvento codiceEvento = new AnaCodiceEvento(id: 1)
        }

        then:
        combinazione.codiceMovimento == ECodiceMovimento.ISCRIZIONE_APR
        combinazione.codiceEvento != null
        combinazione.codiceEvento.id == 1
    }
}
