package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.archivi.ArcParametroService
import spock.lang.Specification

abstract class WspaServiceFactorySpecBase<T> extends Specification {

    ArcParametroService arcParametroService

    abstract T getDepagService()

    abstract T getNextStepService()

    abstract WspaServiceFactory<T> getFactory()

    void setup() {
        arcParametroService = Mock(ArcParametroService)
    }

    def "Ritorna il servizio Depag quando servizioPagamento Depag"() {
        given:
        arcParametroService.getServizioPagamento() >> EServizioPagamento.DEPAG

        expect:
        factory.getService() == getDepagService()
    }

    def "Ritorna il servizio NextStep quando servizioPagamento NextStep"() {
        given:
        arcParametroService.getServizioPagamento() >> EServizioPagamento.NEXTSTEP

        expect:
        factory.getService() == getNextStepService()
    }

    def "Lancia eccezione se il servizioPagamento non è valido"() {
        given:
        arcParametroService.getServizioPagamento() >> null

        when:
        factory.getService()

        then:
        thrown(IllegalStateException)
    }
}