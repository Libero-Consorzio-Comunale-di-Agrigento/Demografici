package it.finmatica.de4gsdzk.pagamento.nextstep


import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviareService
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviareServiceSpec
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepPagamentoDaInviareRepository

class NextStepPagamentoDaInviareServiceSpec extends WspaPagamentoDaInviareServiceSpec {

    NextStepPagamentoDaInviareService nextStepPagamentoDaInviareService

    void setup() {
        NextStepPagamentoDaInviareRepository nextStepPagamentoDaInviareRepository = Mock(NextStepPagamentoDaInviareRepository)
        nextStepPagamentoDaInviareService = new NextStepPagamentoDaInviareService(statoCivileService, utenteCustomService, nextStepPagamentoDaInviareRepository)
    }

    @Override
    WspaPagamentoDaInviareService getService() {
        return nextStepPagamentoDaInviareService
    }

}
