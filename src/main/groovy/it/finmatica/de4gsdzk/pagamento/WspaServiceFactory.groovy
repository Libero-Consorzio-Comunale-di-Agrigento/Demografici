package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.archivi.ArcParametroService

abstract class WspaServiceFactory<T> {
    private final ArcParametroService arcParametroService
    private final T depagService
    private final T nextStepService

    WspaServiceFactory(ArcParametroService arcParametroService, T depagService, T nextStepService) {
        this.arcParametroService = Objects.requireNonNull(arcParametroService, "ArcParametroService must not be null")
        this.depagService = Objects.requireNonNull(depagService, "DepagService must not be null")
        this.nextStepService = Objects.requireNonNull(nextStepService, "NextStepService must not be null")
    }

    T getService() {
        switch (arcParametroService.getServizioPagamento()) {
            case EServizioPagamento.DEPAG:
                return depagService
            case EServizioPagamento.NEXTSTEP:
                return nextStepService
            default:
                throw new IllegalStateException("Unknown EServizioPagamento: ${arcParametroService.getServizioPagamento()}")
        }
    }
}
