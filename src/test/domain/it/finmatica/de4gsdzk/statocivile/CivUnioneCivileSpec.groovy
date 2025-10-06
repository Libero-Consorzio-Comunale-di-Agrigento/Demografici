package it.finmatica.de4gsdzk.statocivile

import spock.lang.Specification

class CivUnioneCivileSpec extends Specification {

    void 'hasParte return true, hasSerie return false'() {
        when:
        CivUnioneCivile u = new CivUnioneCivile()

        then:
        u.hasParte()
        !u.hasSerie()
    }

}
