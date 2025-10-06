package it.finmatica.de4gsdzk.statocivile

import spock.lang.Specification

class CivPubblicazioneSpec extends Specification {

    void 'hasParte and hasSerie return false'() {
        when:
        CivPubblicazione p = new CivPubblicazione()

        then:
        !p.hasParte()
        !p.hasSerie()
    }
}
