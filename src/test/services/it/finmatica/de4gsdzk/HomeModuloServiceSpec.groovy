package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.EModulo
import spock.lang.Specification

class HomeModuloServiceSpec extends Specification {

    HomeModuloService homeModuloService
    CompetenzaService competenzaService

    void setup() {
        competenzaService = Mock(CompetenzaService)
        homeModuloService = new HomeModuloService(competenzaService)
    }

    void 'Moduli abilitati in base alle competenze'() {
        given:
        competenzaService.isCivAny() >> civAny
        competenzaService.isCerAny() >> cerAny
        competenzaService.isAnaAny() >> anaAny

        when:
        List<EModulo> modules = homeModuloService.listModuliAbilitati()

        then:
        modules == expectedModules

        where:
        cerAny | civAny | anaAny | expectedModules
        true   | true   | false  | [EModulo.CERTIFICAZIONE, EModulo.STATO_CIVILE, EModulo.SMART_STATS]
        false  | true   | false  | [EModulo.STATO_CIVILE, EModulo.SMART_STATS]
        true   | false  | false  | [EModulo.CERTIFICAZIONE, EModulo.SMART_STATS]
        false  | false  | false  | [EModulo.SMART_STATS]
        true   | true   | true   | [EModulo.CERTIFICAZIONE, EModulo.ANAGRAFE, EModulo.STATO_CIVILE, EModulo.SMART_STATS]
        false  | true   | true   | [EModulo.ANAGRAFE, EModulo.STATO_CIVILE, EModulo.SMART_STATS]
        true   | false  | true   | [EModulo.CERTIFICAZIONE, EModulo.ANAGRAFE, EModulo.SMART_STATS]
        false  | false  | true   | [EModulo.ANAGRAFE, EModulo.SMART_STATS]

    }
}
