package it.finmatica.de4gsdzk.statocivile

class CivMorteSpec {

    void 'hasParte and hasSerie return true'() {
        when:
        CivMorte m = new CivMorte()

        then:
        m.hasParte()
        m.hasSerie()
    }
}
