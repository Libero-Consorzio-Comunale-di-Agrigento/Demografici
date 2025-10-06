package it.finmatica.de4gsdzk.pagamento


import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoInviatoService
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepPagamentoInviatoService

class WspaPagamentoInviatoServiceFactorySpec extends WspaServiceFactorySpecBase<WspaPagamentoInviatoService> {

    DepagPagamentoInviatoService depagService
    NextStepPagamentoInviatoService nextStepService
    WspaPagamentoInviatoServiceFactory factory

    void setup() {
        depagService = Mock(DepagPagamentoInviatoService)
        nextStepService = Mock(NextStepPagamentoInviatoService)
        factory = new WspaPagamentoInviatoServiceFactory(arcParametroService, depagService, nextStepService)
    }

    @Override
    WspaPagamentoInviatoService getDepagService() {
        return depagService
    }

    @Override
    WspaPagamentoInviatoService getNextStepService() {
        return nextStepService
    }

    @Override
    WspaServiceFactory<WspaPagamentoInviatoService> getFactory() {
        return factory
    }

}
