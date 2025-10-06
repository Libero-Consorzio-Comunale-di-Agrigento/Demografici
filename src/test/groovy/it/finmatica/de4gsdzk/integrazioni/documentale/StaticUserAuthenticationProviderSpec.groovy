package it.finmatica.de4gsdzk.integrazioni.documentale

import it.finmatica.smartdoc.api.login.Utente
import spock.lang.Specification

class StaticUserAuthenticationProviderSpec extends Specification {

    def "utente statico è GDM"() {
        given:
        StaticUserAuthenticationProvider provider = new StaticUserAuthenticationProvider()

        when:
        Utente user = provider.getUtente()

        then:
        user.id == 'GDM'
    }
}
