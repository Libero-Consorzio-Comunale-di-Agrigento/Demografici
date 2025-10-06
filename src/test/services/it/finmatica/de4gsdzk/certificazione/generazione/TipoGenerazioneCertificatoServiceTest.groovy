package it.finmatica.de4gsdzk.certificazione.generazione

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.anpr.AnprTipoCertificatoEsterno
import it.finmatica.de4gsdzk.ansc.AnscTipoCertificatoEsterno
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.utils.ETipoCompetenzaCertificazioneOnLine
import spock.lang.Specification
import spock.lang.Unroll

class TipoGenerazioneCertificatoServiceTest extends Specification {
    TipoGenerazioneCertificatoService generazioneCertificatoService
    ArcParametroService arcParametroService
    CivAttoService civAttoService

    void setup() {
        arcParametroService = Mock(ArcParametroService)
        civAttoService = Mock(CivAttoService)
        generazioneCertificatoService = new TipoGenerazioneCertificatoService(arcParametroService, civAttoService)
    }

    @Unroll
    void 'Dovrebbe ritornare tipoGenerazioneCertificato #expectedTipoGenerazioneCertificato in base al tipoCompetenzaOnline #tipoCompetenzaOnline'() {
        given:
        CerCategoriaTipoCertificato categoria = new CerCategoriaTipoCertificato(tipoCompetenzaOnline: tipoCompetenzaOnline)
        CerTipoCertificato tipoCertificato = new CerTipoCertificato(categoriaTipoCertificato: categoria,
                tipoCertificatoEsterno: tipoCertificatoEsterno)
        arcParametroService.isIntegrazioneAnscAttiva() >> anscOn

        when:
        ETipoGenerazioneCertificato tipoGenerazioneCertificato = generazioneCertificatoService.get(forceGenerazioneGte, tipoCertificato)

        then:
        assert tipoGenerazioneCertificato == expectedTipoGenerazioneCertificato: """
            Test failed for:
            tipoCompetenzaOnline: $tipoCompetenzaOnline
            anscOn: $anscOn
            forceGenerazioneGte: $forceGenerazioneGte
            tipoCertificatoEsterno: $tipoCertificatoEsterno
            expected: $expectedTipoGenerazioneCertificato, but got: $tipoGenerazioneCertificato
        """

        where:
        tipoCompetenzaOnline                   | anscOn | forceGenerazioneGte | tipoCertificatoEsterno           | expectedTipoGenerazioneCertificato
        ETipoCompetenzaCertificazioneOnLine.SC | true   | false               | null                             | ETipoGenerazioneCertificato.GTE
        ETipoCompetenzaCertificazioneOnLine.SC | true   | false               | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.ANSC
        ETipoCompetenzaCertificazioneOnLine.SC | true   | true                | null                             | ETipoGenerazioneCertificato.GTE
        ETipoCompetenzaCertificazioneOnLine.SC | true   | true                | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
        ETipoCompetenzaCertificazioneOnLine.SC | false  | false               | null                             | ETipoGenerazioneCertificato.GTE
        ETipoCompetenzaCertificazioneOnLine.SC | false  | false               | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
        ETipoCompetenzaCertificazioneOnLine.SC | false  | true                | null                             | ETipoGenerazioneCertificato.GTE
        ETipoCompetenzaCertificazioneOnLine.SC | false  | true                | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
        ETipoCompetenzaCertificazioneOnLine.AN | null   | false               | null                             | ETipoGenerazioneCertificato.GTE
        ETipoCompetenzaCertificazioneOnLine.AN | null   | false               | Mock(AnprTipoCertificatoEsterno) | ETipoGenerazioneCertificato.ANPR
        ETipoCompetenzaCertificazioneOnLine.AN | null   | true                | null                             | ETipoGenerazioneCertificato.GTE
        ETipoCompetenzaCertificazioneOnLine.AN | null   | true                | Mock(AnprTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
    }

    @Unroll
    void 'Dovrebbe ritornare tipoGenerazioneCertificato #expectedTipoGenerazioneCertificato, se anscOn #anscOn e se presente atto con invio Ansc #inviatoAnsc'() {
        given:
        CerCategoriaTipoCertificato categoria = new CerCategoriaTipoCertificato(tipoCompetenzaOnline: ETipoCompetenzaCertificazioneOnLine.SC)
        CerTipoCertificato tipoCertificato = new CerTipoCertificato(categoriaTipoCertificato: categoria,
                tipoCertificatoEsterno: tipoCertificatoEsterno)
        CivAttoBaseDomain atto = Mock(CivAttoBaseDomain)
        civAttoService.isInviatoAnsc(_, _) >> inviatoAnsc
        arcParametroService.isIntegrazioneAnscAttiva() >> anscOn

        when:
        ETipoGenerazioneCertificato tipoGenerazioneCertificato = generazioneCertificatoService.get(forceGenerazioneGte, tipoCertificato, atto)

        then:
        assert tipoGenerazioneCertificato == expectedTipoGenerazioneCertificato: """
            Test failed for:
            anscOn: $anscOn
            inviatoAnsc: $inviatoAnsc
            forceGenerazioneGte: $forceGenerazioneGte
            tipoCertificatoEsterno: $tipoCertificatoEsterno
            expected: $expectedTipoGenerazioneCertificato, but got: $tipoGenerazioneCertificato
        """

        where:
        anscOn | inviatoAnsc | forceGenerazioneGte | tipoCertificatoEsterno           | expectedTipoGenerazioneCertificato
        true   | true        | false               | null                             | ETipoGenerazioneCertificato.GTE
        true   | true        | false               | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.ANSC
        true   | true        | true                | null                             | ETipoGenerazioneCertificato.GTE
        true   | true        | true                | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
        true   | false       | false               | null                             | ETipoGenerazioneCertificato.GTE
        true   | false       | false               | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
        true   | false       | true                | null                             | ETipoGenerazioneCertificato.GTE
        true   | false       | true                | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
        false  | true        | false               | null                             | ETipoGenerazioneCertificato.GTE
        false  | true        | false               | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
        false  | true        | true                | null                             | ETipoGenerazioneCertificato.GTE
        false  | true        | true                | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
        false  | false       | false               | null                             | ETipoGenerazioneCertificato.GTE
        false  | false       | false               | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
        false  | false       | true                | null                             | ETipoGenerazioneCertificato.GTE
        false  | false       | true                | Mock(AnscTipoCertificatoEsterno) | ETipoGenerazioneCertificato.GTE
    }
}
