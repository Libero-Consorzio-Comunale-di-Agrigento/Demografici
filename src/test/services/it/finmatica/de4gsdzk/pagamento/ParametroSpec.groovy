package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.archivi.ArcParametroRepository
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import spock.lang.Specification
import spock.lang.Unroll

class ParametroSpec extends Specification {
    private static final String WSPA_DEPAG = 'DEPAG'
    private static final String WSPA_NEXTSTEP = 'NEXTSTEP'
    private static final String WSPA_XYZ = 'XYZ'

    private static final String S = 'S'
    private static final String N = 'N'

    ArcParametroRepository arcParametroRepository
    ArcParametroService arcParametroService

    void setup() {
        arcParametroRepository = Mock(ArcParametroRepository)
        arcParametroService = new ArcParametroService(arcParametroRepository)
    }

    @Unroll
    void 'Integrazione pagamenti attiva quando #parametro=#valore'() {
        given:
        String parametro = ArcParametro.WSPA
        arcParametroRepository.findById(parametro) >> { String id -> new ArcParametro(id: id, valore: valore) }

        when:
        Boolean attiva = arcParametroService.isIntegrazionePagamentiAttiva()

        then:
        attiva

        where:
        valore << [WSPA_DEPAG, WSPA_NEXTSTEP]
    }

    void 'Integrazione pagamenti non attiva quando #parametro=#valore'() {
        given:
        String parametro = ArcParametro.WSPA
        arcParametroRepository.findById(parametro) >> { String id -> new ArcParametro(id: id, valore: valore) }

        when:
        Boolean attiva = arcParametroService.isIntegrazionePagamentiAttiva()

        then:
        !attiva

        where:
        valore << [null, WSPA_XYZ]
    }

    @Unroll
    void 'Servizio Esterno servizio è #expected quando #parametro=#valore'() {
        given:
        String parametro = ArcParametro.WSPA
        arcParametroRepository.findById(parametro) >> { String id -> new ArcParametro(id: id, valore: valore) }

        when:
        EServizioPagamento servizio = arcParametroService.getServizioPagamento()

        then:
        servizio == expected

        where:
        valore        | expected
        WSPA_DEPAG    | EServizioPagamento.DEPAG
        WSPA_NEXTSTEP | EServizioPagamento.NEXTSTEP
    }

    void 'Servizio Esterno non valido lancia eccezione'() {
        given:
        String parametro = ArcParametro.WSPA
        arcParametroRepository.findById(parametro) >> { String id -> new ArcParametro(id: id, valore: WSPA_XYZ) }

        when:
        EServizioPagamento servizioPagamento = arcParametroService.getServizioPagamento()

        then:
        thrown(IllegalStateException)
    }

    @Unroll
    void 'Visualizzazione Familiari Cancellati con attivazione = #expected quando #parametro=#valore'() {
        given:
        String parametro = ArcParametro.VANA_2FAM
        arcParametroRepository.findById(parametro) >> { String id -> new ArcParametro(id: id, valore: valore) }

        when:
        Boolean attiva = arcParametroService.isVisualizzazioneFamiliariCancellatiAttiva()

        then:
        attiva == expected

        where:
        valore | expected
        S      | true
        N      | false
        null   | false
    }


}
