package it.finmatica.de4gsdzk.pagamento.depag

import it.finmatica.de4gsdzk.pagamento.EFunzionePagamentoInviato
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviato
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviatoService
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviatoServiceSpec
import it.finmatica.de4gsdzk.utils.Funzioni
import spock.lang.Unroll

class DepagPagamentoInviatoServiceSpec extends WspaPagamentoInviatoServiceSpec {
    private static String CHIAVE_SERVIZIO_ESTERNO = "1234"
    private static String BASE_URL_SERVIZIO_ESTERNO = "http://depag/"

    DepagPagamentoInviatoService depagPagamentoInviatoService

    void setup() {
        depagPagamentoInviatoService = new DepagPagamentoInviatoService(gsdService, utenteCustomService, wspaPagamentoInviatoRepository)
    }

    @Override
    WspaPagamentoInviatoService getService() {
        return depagPagamentoInviatoService
    }

    void 'Ottieni URL costruito'() {
        given:
        gsdService.getUrlWspa(CHIAVE_SERVIZIO_ESTERNO) >> BASE_URL_SERVIZIO_ESTERNO + CHIAVE_SERVIZIO_ESTERNO
        WspaPagamentoInviato wspaPagamentoInviato = new WspaPagamentoInviato(chiaveServizioEsterno: CHIAVE_SERVIZIO_ESTERNO)

        when:
        String url = depagPagamentoInviatoService.getUrl(wspaPagamentoInviato)

        then:
        url == BASE_URL_SERVIZIO_ESTERNO + CHIAVE_SERVIZIO_ESTERNO
    }

    @Unroll
    void "Visibilità di #funzionePagamento per pagamentoInviato=#pagamentoInviato è #expectedVisibility"() {
        given:
        WspaPagamentoInviato wspaPagamentoInviato = Mock(WspaPagamentoInviato)
        wspaPagamentoInviato.isInviatoConSuccesso() >> pagamentoInviato

        when:
        Funzioni funzioniPagamentoDepag = depagPagamentoInviatoService.getFunzioniPagamentoInviato(wspaPagamentoInviato)

        then:
        funzioniPagamentoDepag.isVisible(funzionePagamento) == expectedVisibility

        where:
        funzionePagamento                     | pagamentoInviato || expectedVisibility
        EFunzionePagamentoInviato.RIPETIZIONE | false            || true
        EFunzionePagamentoInviato.RIPETIZIONE | true             || false
        EFunzionePagamentoInviato.CONFERMA    | true             || true
        EFunzionePagamentoInviato.CONFERMA    | false            || false
        EFunzionePagamentoInviato.VERIFICA    | true             || false
        EFunzionePagamentoInviato.VERIFICA    | false            || false
        EFunzionePagamentoInviato.ANNULLA     | true             || true
        EFunzionePagamentoInviato.ANNULLA     | false            || false
    }


}
