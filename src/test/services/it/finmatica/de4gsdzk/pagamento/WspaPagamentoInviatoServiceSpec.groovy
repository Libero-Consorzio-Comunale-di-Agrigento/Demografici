package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.error.InvioPagamentoRuntimeException
import it.finmatica.de4gsdzk.GsdService
import spock.lang.Specification

abstract class WspaPagamentoInviatoServiceSpec extends Specification {
    private static String RESPONSE_INVIO_PAGAMENTO_SUCCESSO = ""
    private static String RESPONSE_INVIO_PAGAMENTO_ERRORE = "Lorem ipsum"
    private static Integer ANNO_PAGAMENTO = 2025
    private static Integer PROGR_PAGAMENTO = 35
    private static String UTENTE_PAGAMENTO = "MISTERX"

    GsdService gsdService
    UtenteCustomService utenteCustomService
    WspaPagamentoInviatoRepository wspaPagamentoInviatoRepository

    void setup() {
        gsdService = Mock(GsdService)
        utenteCustomService = Mock(UtenteCustomService)
        utenteCustomService.getLoggedUserId() >> UTENTE_PAGAMENTO
        wspaPagamentoInviatoRepository = Mock(WspaPagamentoInviatoRepository)
    }

    abstract WspaPagamentoInviatoService getService()

    void 'Se Ripeti Invio restituisce successo, concludi senza eccezioni'() {
        given:
        WspaPagamentoInviato wspaPagamentoInviato = new WspaPagamentoInviato(anno: ANNO_PAGAMENTO, progressivo: PROGR_PAGAMENTO)
        gsdService.invioPagamentoWspa(ANNO_PAGAMENTO, PROGR_PAGAMENTO, UTENTE_PAGAMENTO) >> RESPONSE_INVIO_PAGAMENTO_SUCCESSO

        when:
        getService().inviaPagamento(wspaPagamentoInviato)

        then:
        noExceptionThrown()
    }

    void 'Se Ripeti Invio restituisce errore, lancia eccezione'() {
        given:
        WspaPagamentoInviato wspaPagamentoInviato = new WspaPagamentoInviato(anno: ANNO_PAGAMENTO, progressivo: PROGR_PAGAMENTO)
        gsdService.invioPagamentoWspa(ANNO_PAGAMENTO, PROGR_PAGAMENTO, UTENTE_PAGAMENTO) >> RESPONSE_INVIO_PAGAMENTO_ERRORE

        when:
        getService().inviaPagamento(wspaPagamentoInviato)

        then:
        thrown(InvioPagamentoRuntimeException)
    }
}
