package it.finmatica.de4gsdzk.certificazione.emissione

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.certificazione.CerStatoCivileFiltroService
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerTipoRichiedente
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.certificazione.generazione.TipoGenerazioneCertificatoService
import it.finmatica.de4gsdzk.statocivile.CivMessaggioService
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAttoService
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.utils.ETipoAtto
import spock.lang.Specification
import spock.lang.Unroll

class EmissioneCertificatoStatoCivileServiceTest extends Specification {

    EmissioneCertificatoStatoCivileService emissioneCertificatoStatoCivileService
    TipoGenerazioneCertificatoService tipoGenerazioneCertificatoService

    void setup() {
        tipoGenerazioneCertificatoService = Mock(TipoGenerazioneCertificatoService)
        CerStatoCivileFiltroService cerStatoCivileFiltroService = Mock(CerStatoCivileFiltroService)
        CerTerminalistaService cerTerminalistaService = Mock(CerTerminalistaService)
        CivAttoService civAttoService = Mock(CivAttoService)
        CivAnnotazioneAttoService civAnnotazioneAttoService = Mock(CivAnnotazioneAttoService)
        CivMessaggioService civMessaggioService = Mock(CivMessaggioService)
        emissioneCertificatoStatoCivileService = new EmissioneCertificatoStatoCivileService(
                cerStatoCivileFiltroService,
                cerTerminalistaService,
                civAttoService,
                civAnnotazioneAttoService,
                civMessaggioService,
                tipoGenerazioneCertificatoService)
    }

    @Unroll
    void 'Mostra avviso richiedente dovrebbe restituire #expectedShouldShow, se Tipo Richiedente #tipoRichiedenteId e se Tipo Generazione Certificato #tipoGenerazioneCertificato'() {
        given:
        CerTipoRichiedente tipoRichiedente = new CerTipoRichiedente(id: tipoRichiedenteId)
        Boolean forceGenerazioneGte = Boolean.FALSE
        CerTipoCertificato tipoCertificato = new CerTipoCertificato()
        tipoGenerazioneCertificatoService.get(forceGenerazioneGte, tipoCertificato) >> tipoGenerazioneCertificato

        when:
        Boolean shouldShow = emissioneCertificatoStatoCivileService.shouldShowAnscRichiedenteWarning(tipoRichiedente, forceGenerazioneGte, tipoCertificato)

        then:
        shouldShow == expectedShouldShow

        where:
        tipoGenerazioneCertificato       | tipoRichiedenteId                     | expectedShouldShow
        ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false
        ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false

    }

    @Unroll
    void 'Mostra avviso richiedente dovrebbe restituire #expectedShouldShow, se Tipo Richiedente #tipoRichiedenteId, se Tipo Generazione Certificato #tipoGenerazioneCertificato, se Tipo Atto #tipoAtto'() {
        given:
        CerTipoRichiedente tipoRichiedente = new CerTipoRichiedente(id: tipoRichiedenteId)

        Boolean forceGenerazioneGte = Boolean.FALSE
        CerTipoCertificato tipoCertificato = new CerTipoCertificato(tipoAttoEnum: tipoAtto)
        tipoGenerazioneCertificatoService.get(forceGenerazioneGte, tipoCertificato) >> tipoGenerazioneCertificato

        when:
        Boolean shouldShow = emissioneCertificatoStatoCivileService.shouldShowAnscMorteRichiedenteWarning(tipoRichiedente, forceGenerazioneGte, tipoCertificato)

        then:
        shouldShow == expectedShouldShow

        where:
        tipoAtto      | tipoGenerazioneCertificato       | tipoRichiedenteId                     | expectedShouldShow
        ETipoAtto.MOR | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoAtto.MOR | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoAtto.MOR | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false
        ETipoAtto.MOR | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoAtto.MOR | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoAtto.MOR | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false
        ETipoAtto.NAS | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoAtto.NAS | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoAtto.NAS | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false
        ETipoAtto.NAS | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoAtto.NAS | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoAtto.NAS | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false
        ETipoAtto.MAT | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoAtto.MAT | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoAtto.MAT | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false
        ETipoAtto.MAT | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoAtto.MAT | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoAtto.MAT | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false
        ETipoAtto.CIT | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoAtto.CIT | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoAtto.CIT | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false
        ETipoAtto.CIT | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoAtto.CIT | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoAtto.CIT | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false
        ETipoAtto.UCI | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoAtto.UCI | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoAtto.UCI | ETipoGenerazioneCertificato.ANSC | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false
        ETipoAtto.UCI | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoAtto.UCI | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoAtto.UCI | ETipoGenerazioneCertificato.GTE  | CerTipoRichiedente.ALTRO_RICHIEDENTE  | false

    }

    @Unroll
    void 'Abilitazione certificazione stato civile in base ad atto'() {
        given:
        CerTipoRichiedente tipoRichiedente = new CerTipoRichiedente(id: tipoRichiedenteId)
        tipoGenerazioneCertificatoService.get(_, _, _) >> tipoGenerazioneCertificato

        when:
        Boolean shouldEnable = emissioneCertificatoStatoCivileService.shouldEnableEmissioneCertificatoSuAtto(tipoAtto, tipoRichiedente, Mock(Object) as Boolean, Mock(CerTipoCertificato), Mock(CivAttoBaseDomain))

        then:
        assert shouldEnable == expectedShouldEnable: """
            Test failed for:
            tipoGenerazioneCertificato: $tipoGenerazioneCertificato
            tipoAtto: $tipoAtto
            tipoRichiedenteId: $tipoRichiedenteId
            expected: $expectedShouldEnable, but got: $shouldEnable
        """

        where:
        tipoGenerazioneCertificato       | tipoAtto      | tipoRichiedenteId                     | expectedShouldEnable
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.NAS | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.NAS | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.NAS | CerTipoRichiedente.ALTRO_RICHIEDENTE  | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.MAT | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.MAT | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.MAT | CerTipoRichiedente.ALTRO_RICHIEDENTE  | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.UCI | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.UCI | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.UCI | CerTipoRichiedente.ALTRO_RICHIEDENTE  | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.CIT | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.CIT | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.CIT | CerTipoRichiedente.ALTRO_RICHIEDENTE  | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.MOR | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.MOR | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoGenerazioneCertificato.GTE  | ETipoAtto.MOR | CerTipoRichiedente.ALTRO_RICHIEDENTE  | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.NAS | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.NAS | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.NAS | CerTipoRichiedente.ALTRO_RICHIEDENTE  | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.MAT | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.MAT | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.MAT | CerTipoRichiedente.ALTRO_RICHIEDENTE  | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.UCI | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.UCI | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.UCI | CerTipoRichiedente.ALTRO_RICHIEDENTE  | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.CIT | CerTipoRichiedente.ISTANZA_DI_PARTE   | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.CIT | CerTipoRichiedente.ISTANZA_DI_UFFICIO | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.CIT | CerTipoRichiedente.ALTRO_RICHIEDENTE  | true
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.MOR | CerTipoRichiedente.ISTANZA_DI_PARTE   | false
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.MOR | CerTipoRichiedente.ISTANZA_DI_UFFICIO | false
        ETipoGenerazioneCertificato.ANSC | ETipoAtto.MOR | CerTipoRichiedente.ALTRO_RICHIEDENTE  | true

    }
}
