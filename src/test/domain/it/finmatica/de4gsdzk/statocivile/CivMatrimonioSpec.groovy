package it.finmatica.de4gsdzk.statocivile

import spock.lang.Specification

class CivMatrimonioSpec extends Specification {

    void 'hasParte and hasSerie return true'() {
        when:
        CivMatrimonio m = new CivMatrimonio()

        then:
        m.hasParte()
        m.hasSerie()
    }

}
