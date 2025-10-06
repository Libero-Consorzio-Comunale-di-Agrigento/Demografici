package it.finmatica.de4gsdzk.pagamento


import it.finmatica.de4gsdzk.pagamento.depag.DepagParametroService
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepParametroService

class WspaParametroServiceFactorySpec extends WspaServiceFactorySpecBase<IWspaParametroService> {

    DepagParametroService depagService
    NextStepParametroService nextStepService
    WspaParametroServiceFactory factory

    void setup() {
        depagService = Mock(DepagParametroService)
        nextStepService = Mock(NextStepParametroService)
        factory = new WspaParametroServiceFactory(arcParametroService, depagService, nextStepService)
    }

    @Override
    IWspaParametroService getDepagService() {
        return depagService
    }

    @Override
    IWspaParametroService getNextStepService() {
        return nextStepService
    }

    @Override
    WspaServiceFactory<IWspaParametroService> getFactory() {
        return factory
    }
}