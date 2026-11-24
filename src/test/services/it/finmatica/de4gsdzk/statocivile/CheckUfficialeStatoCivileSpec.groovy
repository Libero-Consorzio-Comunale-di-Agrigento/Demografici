package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CompetenzaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import spock.lang.Specification

class CheckUfficialeStatoCivileSpec extends Specification {
    CivValidazioneAttoService civValidazioneAttoService

    def setup() {
        CivTipoAttoService civTipoAttoService = Mock(CivTipoAttoService)
        GsdService gsdService = Mock(GsdService)
        CompetenzaService competenzaService = Mock(CompetenzaService)
        CivTipoComprensioneService civTipoComprensioneService = Mock(CivTipoComprensioneService)
        civValidazioneAttoService = new CivValidazioneAttoService(civTipoAttoService, gsdService, competenzaService, civTipoComprensioneService)
    }

    def "non deve lanciare eccezione quando ufficiale è presente e obbligatorio per l'atto"() {
        given:
        CivUnioneCivile atto = Mock(CivUnioneCivile)
        atto.isUfficialeStatoCivileMandatory() >> true
        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.ufficialeUtente = "Mario Rossi"

        when:
        civValidazioneAttoService.checkUfficialeStatoCivile(atto, datiProvenienza)

        then:
        noExceptionThrown()
    }

    def "deve lanciare eccezione quando ufficiale è assente e obbligatorio per l'atto"() {
        given:
        CivUnioneCivile atto = Mock(CivUnioneCivile)
        atto.isUfficialeStatoCivileMandatory() >> true
        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.ufficialeUtente = null

        when:
        civValidazioneAttoService.checkUfficialeStatoCivile(atto, datiProvenienza)

        then:
        thrown(CampoMandatoryRuntimeException)
    }

    def "non deve lanciare eccezione quando ufficiale è presente e obbligatorio per l'atto"() {
        given:
        CivMatrimonio atto = Mock(CivMatrimonio)
        atto.isUfficialeStatoCivileMandatory() >> true
        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.ufficialeUtente = "Mario Rossi"

        when:
        civValidazioneAttoService.checkUfficialeStatoCivile(atto, datiProvenienza)

        then:
        noExceptionThrown()
    }

    def "deve lanciare eccezione quando ufficiale è assente e obbligatorio per l'atto"() {
        given:
        CivMatrimonio atto = Mock(CivMatrimonio)
        atto.isUfficialeStatoCivileMandatory() >> true
        CivDatiProvenienzaAtto datiProvenienza = new CivDatiProvenienzaAtto()
        datiProvenienza.ufficialeUtente = null

        when:
        civValidazioneAttoService.checkUfficialeStatoCivile(atto, datiProvenienza)

        then:
        thrown(CampoMandatoryRuntimeException)
    }
}
