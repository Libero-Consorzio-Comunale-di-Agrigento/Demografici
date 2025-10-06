package it.finmatica.de4gsdzk.anagrafe


import spock.lang.Specification

class AnaConvivenzaDiFattoSpec extends Specification {

    void "Convivenza espone i dati richiesti"() {
        given:
        AnaConvivenzaDiFatto convivenza = new AnaConvivenzaDiFatto()

        expect:
        convivenza.hasProperty("id")
        convivenza.hasProperty("conviventi")
        convivenza.hasProperty("comuneInizio")
        convivenza.hasProperty("praticaInizio")
        convivenza.hasProperty("annoPraticaInizio")
        convivenza.hasProperty("dataInizio")
        convivenza.hasProperty("comuneFine")
        convivenza.hasProperty("praticaFine")
        convivenza.hasProperty("annoPraticaFine")
        convivenza.hasProperty("dataFine")
        convivenza.hasProperty("note")
        convivenza.hasProperty("dataRegistrazione")
        convivenza.hasProperty("statoConvivenza")
    }
}
