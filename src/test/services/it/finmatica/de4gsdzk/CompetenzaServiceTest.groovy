package it.finmatica.de4gsdzk

import it.finmatica.ad4.autenticazione.Ad4Ruolo
import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.de4gsdzk.utils.ERuoloAd4
import it.finmatica.de4gsdzk.utils.ERuoloSo4
import it.finmatica.so4.login.So4SpringSecurityService
import it.finmatica.so4.login.So4UserDetail
import it.finmatica.so4.login.detail.UnitaOrganizzativa
import spock.lang.Specification

class CompetenzaServiceTest extends Specification {
    CompetenzaService competenzaService
    So4SpringSecurityService so4SpringSecurityService

    void setup() {
        so4SpringSecurityService = Mock(So4SpringSecurityService)
        competenzaService = new CompetenzaService(so4SpringSecurityService)
    }

    def "Utente in struttura organizzativa dovrebbe essere CivSuperUser se possiede il ruolo"() {
        given:
        Ad4Utente userAd4 = Mock(Ad4Utente)
        userAd4.ruoli >> [new Ad4Ruolo(id: ERuoloAd4.AMM.id)]

        So4UserDetail userSo4 = Mock(So4UserDetail)
        userSo4.uo() >> [Mock(UnitaOrganizzativa)]
        userSo4.utente >> userAd4
        userSo4.hasRuolo(ERuoloSo4.CIV_SUPERUSER.id) >> true
        so4SpringSecurityService.principal >> userSo4

        when:
        boolean result = competenzaService.isCivSuperUser()
        then:
        result
    }

    def "Utente in struttura organizzativa dovrebbe essere CerSuperUser se possiede il ruolo"() {
        given:
        Ad4Utente userAd4 = Mock(Ad4Utente)
        userAd4.ruoli >> [new Ad4Ruolo(id: ERuoloAd4.AMM.id)]

        So4UserDetail userSo4 = Mock(So4UserDetail)
        userSo4.uo() >> [Mock(UnitaOrganizzativa)]
        userSo4.utente >> userAd4
        userSo4.hasRuolo(ERuoloSo4.CER_SUPERUSER.id) >> true
        so4SpringSecurityService.principal >> userSo4

        when:
        boolean result = competenzaService.isCerSuperUser()
        then:
        result
    }

    def "Utente in struttura organizzativa dovrebbe essere AnaSuperUser se possiede il ruolo"() {
        given:
        Ad4Utente userAd4 = Mock(Ad4Utente)
        userAd4.ruoli >> [new Ad4Ruolo(id: ERuoloAd4.AMM.id)]

        So4UserDetail userSo4 = Mock(So4UserDetail)
        userSo4.uo() >> [Mock(UnitaOrganizzativa)]
        userSo4.utente >> userAd4
        userSo4.hasRuolo(ERuoloSo4.ANA_SUPERUSER.id) >> true
        so4SpringSecurityService.principal >> userSo4

        when:
        boolean result = competenzaService.isAnaSuperUser()
        then:
        result
    }
}
