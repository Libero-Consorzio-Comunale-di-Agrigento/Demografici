package it.finmatica.de4gsdzk.pagamento


import it.finmatica.de4gsdzk.pagamento.depag.DepagVoceCostoService
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepVoceCostoService

class WspaVoceCostoServiceFactorySpec extends WspaServiceFactorySpecBase<IWspaVoceCostoService> {

    DepagVoceCostoService depagService
    NextStepVoceCostoService nextStepService
    WspaVoceCostoServiceFactory factory

    void setup() {
        depagService = Mock(DepagVoceCostoService)
        nextStepService = Mock(NextStepVoceCostoService)
        factory = new WspaVoceCostoServiceFactory(arcParametroService, depagService, nextStepService)
    }

    @Override
    IWspaVoceCostoService getDepagService() {
        return depagService
    }

    @Override
    IWspaVoceCostoService getNextStepService() {
        return nextStepService
    }

    @Override
    WspaServiceFactory<IWspaVoceCostoService> getFactory() {
        return factory
    }
}