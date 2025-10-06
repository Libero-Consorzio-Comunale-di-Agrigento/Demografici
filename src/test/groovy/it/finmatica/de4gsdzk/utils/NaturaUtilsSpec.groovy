package it.finmatica.de4gsdzk.utils

import spock.lang.Specification

class NaturaUtilsSpec extends Specification {

    List<ENaturaAtto> listaCIT, listaNAS, listaPUB

    void setup() {
        listaCIT = [ENaturaAtto.A, ENaturaAtto.P, ENaturaAtto.D, ENaturaAtto.N]
        listaNAS = [ENaturaAtto.O, ENaturaAtto.T, ENaturaAtto.D, ENaturaAtto.N]
        listaPUB = [ENaturaAtto.O, ENaturaAtto.T, ENaturaAtto.N]
    }

    void "getValoriByTipoAtto: restituisce i valori in base al tipo di atto"() {

        when:
        def lista1 = NaturaUtils.getValoriByTipoAtto(ETipoAtto.CIT)
        def lista2 = NaturaUtils.getValoriByTipoAtto(ETipoAtto.NAS)
        def lista3 = NaturaUtils.getValoriByTipoAtto(ETipoAtto.PUB)

        then:
        lista1 == listaCIT
        lista2 == listaNAS
        lista3 == listaPUB

    }

}
