package it.finmatica.de4gsdzk.statocivile

import spock.lang.Specification

class CivProcessoVerbaleSpec extends Specification {

    void 'hasParte and hasSerie return false'() {
        when:
        CivProcessoVerbale p = new CivProcessoVerbale()

        then:
        !p.hasParte()
        !p.hasSerie()
    }

}
