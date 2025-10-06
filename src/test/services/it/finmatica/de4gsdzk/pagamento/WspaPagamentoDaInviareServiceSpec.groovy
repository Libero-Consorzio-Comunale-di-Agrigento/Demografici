package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoDaInviare
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import spock.lang.Specification

abstract class WspaPagamentoDaInviareServiceSpec extends Specification {
    private static String UTENTE_PAGAMENTO = "MISTERX"

    StatoCivileService statoCivileService
    UtenteCustomService utenteCustomService

    abstract WspaPagamentoDaInviareService getService()

    void setup() {
        statoCivileService = Mock(StatoCivileService)
        utenteCustomService = Mock(UtenteCustomService)
        utenteCustomService.getLoggedUserId() >> UTENTE_PAGAMENTO
    }

    void 'Aggiornamento Numero Documento, setta un numero e un progressivo emissione'() {
        given:
        statoCivileService.getNumeroPagamento(_) >>> [1, 2, 3]

        List<WspaPagamentoDaInviare> pagamentiDaInviare = [
                new DepagPagamentoDaInviare(),
                new DepagPagamentoDaInviare(),
                new DepagPagamentoDaInviare()
        ]

        when:
        getService().updateNumeroDocumento(pagamentiDaInviare)

        then:
        pagamentiDaInviare.every {
            it.anno != null && it.progressivo != null
        }
    }

}
