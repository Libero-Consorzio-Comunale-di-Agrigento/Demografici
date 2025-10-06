package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.pagamento.depag.DepagVoceCostoService
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepVoceCostoService
import org.springframework.stereotype.Component

@Component
class WspaVoceCostoServiceFactory extends WspaServiceFactory<IWspaVoceCostoService> {

    WspaVoceCostoServiceFactory(ArcParametroService arcParametroService,
                                DepagVoceCostoService depagService,
                                NextStepVoceCostoService nextStepService) {
        super(arcParametroService, depagService, nextStepService)
    }

}
