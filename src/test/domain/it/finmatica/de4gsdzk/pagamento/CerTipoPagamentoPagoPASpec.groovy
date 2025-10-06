package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.certificazione.CerTipoPagamento
import spock.lang.Specification

class CerTipoPagamentoPagoPASpec extends Specification {
    void 'Tipo pagamento PagoPA attivo'() {
        given:
        CerTipoPagamento cerTipoPagamento = new CerTipoPagamento()

        when:
        cerTipoPagamento.flagPagamentoPagoPA = Boolean.TRUE

        then:
        cerTipoPagamento.isPagamentoPagoPA()
    }

    void 'Tipo pagamento PagoPA non attivo quando nullo'() {
        given:
        CerTipoPagamento cerTipoPagamento = new CerTipoPagamento()

        when:
        cerTipoPagamento.flagPagamentoPagoPA = null

        then:
        !cerTipoPagamento.isPagamentoPagoPA()
    }

    void 'Tipo pagamento PagoPA non attivo quando N'() {
        given:
        CerTipoPagamento cerTipoPagamento = new CerTipoPagamento()

        when:
        cerTipoPagamento.flagPagamentoPagoPA = Boolean.FALSE

        then:
        !cerTipoPagamento.isPagamentoPagoPA()
    }
}
