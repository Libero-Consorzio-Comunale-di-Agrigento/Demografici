package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoInviatoService
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepPagamentoInviatoService
import org.springframework.stereotype.Component

@Component
class WspaPagamentoInviatoServiceFactory extends WspaServiceFactory<WspaPagamentoInviatoService> {

    WspaPagamentoInviatoServiceFactory(ArcParametroService arcParametroService,
                                       DepagPagamentoInviatoService depagService,
                                       NextStepPagamentoInviatoService nextStepService) {
        super(arcParametroService, depagService, nextStepService)
    }

}
