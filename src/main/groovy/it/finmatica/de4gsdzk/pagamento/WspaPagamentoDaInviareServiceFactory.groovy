package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoDaInviareService
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepPagamentoDaInviareService
import org.springframework.stereotype.Component

@Component
class WspaPagamentoDaInviareServiceFactory extends WspaServiceFactory<WspaPagamentoDaInviareService> {

    WspaPagamentoDaInviareServiceFactory(ArcParametroService arcParametroService,
                                         DepagPagamentoDaInviareService depagService,
                                         NextStepPagamentoDaInviareService nextStepService) {
        super(arcParametroService, depagService, nextStepService)
    }

}
