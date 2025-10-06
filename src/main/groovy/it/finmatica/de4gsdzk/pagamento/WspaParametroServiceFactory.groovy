package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.pagamento.depag.DepagParametroService
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepParametroService
import org.springframework.stereotype.Component

@Component
class WspaParametroServiceFactory extends WspaServiceFactory<IWspaParametroService> {

    WspaParametroServiceFactory(ArcParametroService arcParametroService,
                                DepagParametroService depagService,
                                NextStepParametroService nextStepService) {
        super(arcParametroService, depagService, nextStepService)
    }

}
