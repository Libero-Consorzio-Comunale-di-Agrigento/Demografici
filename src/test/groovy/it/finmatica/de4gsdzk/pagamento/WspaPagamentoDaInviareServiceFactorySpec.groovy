package it.finmatica.de4gsdzk.pagamento


import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoDaInviareService
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepPagamentoDaInviareService

class WspaPagamentoDaInviareServiceFactorySpec extends WspaServiceFactorySpecBase<WspaPagamentoDaInviareService> {

    DepagPagamentoDaInviareService depagService
    NextStepPagamentoDaInviareService nextStepService
    WspaPagamentoDaInviareServiceFactory factory

    void setup() {
        depagService = Mock(DepagPagamentoDaInviareService)
        nextStepService = Mock(NextStepPagamentoDaInviareService)
        factory = new WspaPagamentoDaInviareServiceFactory(arcParametroService, depagService, nextStepService)
    }

    @Override
    WspaPagamentoDaInviareService getDepagService() {
        return depagService
    }

    @Override
    WspaPagamentoDaInviareService getNextStepService() {
        return nextStepService
    }

    @Override
    WspaServiceFactory<WspaPagamentoDaInviareService> getFactory() {
        return factory
    }
}