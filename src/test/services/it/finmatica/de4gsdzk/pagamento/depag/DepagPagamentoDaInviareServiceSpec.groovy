package it.finmatica.de4gsdzk.pagamento.depag

import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.CerTipoPagamento
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviare
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviareService
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviareServiceSpec
import it.finmatica.de4gsdzk.pagamento.error.ServizioNonCoerenteRuntimeException
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoDaInviareRepository
import it.finmatica.de4gsdzk.certificazione.RicercaCertificato
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest

class DepagPagamentoDaInviareServiceSpec extends WspaPagamentoDaInviareServiceSpec {

    private static String SERVIZIO_A = 'SERVIZIO_A'
    private static String SERVIZIO_B = 'SERVIZIO_B'

    DepagPagamentoDaInviareService depagPagamentoDaInviareService

    void setup() {
        CerTipoPagamento cerTipoPagamento = new CerTipoPagamento(flagPagamentoPagoPA: true)
        List<WspaPagamentoDaInviare> resultList = [
                new DepagPagamentoDaInviare(certificatoEmesso: new CerCertificatoEmesso(tipoPagamento: cerTipoPagamento)),
                new DepagPagamentoDaInviare(certificatoEmesso: new CerCertificatoEmesso(tipoPagamento: cerTipoPagamento)),
                new DepagPagamentoDaInviare(certificatoEmesso: new CerCertificatoEmesso(tipoPagamento: cerTipoPagamento))
        ]
        Page<WspaPagamentoDaInviare> resultPage = new PageImpl<>(resultList)

        DepagPagamentoDaInviareRepository depagPagamentoDaInviareRepository = Mock(DepagPagamentoDaInviareRepository)
        depagPagamentoDaInviareRepository.findAllByRicercaCertificato(_,_) >> resultPage

        depagPagamentoDaInviareService = new DepagPagamentoDaInviareService(gsdService, utenteCustomService, depagPagamentoDaInviareRepository)
    }

    @Override
    WspaPagamentoDaInviareService getService() {
        return depagPagamentoDaInviareService
    }

    void 'Ottieni solo Pagamenti da Inviare con TipoPagamento abilitato PagoPA'() {
        given:
        PageRequest pageRequest = new PageRequest(0, 10)
        RicercaCertificato r = new RicercaCertificato()

        when:
        List<WspaPagamentoDaInviare> pagamentiDaInviare = depagPagamentoDaInviareService.listAll(r, pageRequest).getContent()

        then:
        pagamentiDaInviare*.certificatoEmesso*.tipoPagamento.every { it.flagPagamentoPagoPA == true }
    }

    void 'Validazione Invio Pagamenti non ammette servizi diversi'() {
        given:
        DepagServizio depagServizioA = new DepagServizio(id: SERVIZIO_A)
        DepagServizio depagServizioB = new DepagServizio(id: SERVIZIO_B)
        List<DepagPagamentoDaInviare> pagamentoDaInviareList = [
                new DepagPagamentoDaInviare(servizio: depagServizioA),
                new DepagPagamentoDaInviare(servizio: depagServizioB),
                new DepagPagamentoDaInviare(servizio: depagServizioB)
        ]

        when:
        depagPagamentoDaInviareService.validaInvioPagamento(pagamentoDaInviareList)

        then:
        thrown(ServizioNonCoerenteRuntimeException)
    }

}
