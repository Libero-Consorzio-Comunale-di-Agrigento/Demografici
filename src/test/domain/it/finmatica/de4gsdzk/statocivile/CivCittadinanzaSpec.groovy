package it.finmatica.de4gsdzk.statocivile

import spock.lang.Specification

class CivCittadinanzaSpec extends Specification {

    void 'hasParte and hasSerie return false'() {
        when:
        CivCittadinanza c = new CivCittadinanza()

        then:
        !c.hasParte()
        !c.hasSerie()
    }

}
