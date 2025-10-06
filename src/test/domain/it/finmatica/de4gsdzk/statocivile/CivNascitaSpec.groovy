package it.finmatica.de4gsdzk.statocivile

import spock.lang.Specification

class CivNascitaSpec extends Specification {

    void 'hasParte and hasSerie return true'() {
        when:
        CivNascita n = new CivNascita()

        then:
        n.hasParte()
        n.hasSerie()
    }

}
