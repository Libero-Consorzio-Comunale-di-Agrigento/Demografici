package it.finmatica.de4gsdzk.statocivile

import spock.lang.Specification

class CivVisualizzazioneDocumentiUscitaSpec extends Specification {

    void "getNominativo: Restituisce cognome e nome concatenati"() {
        when:
        def doc1 = new CivVisualizzazioneDocumentiUscita(nome: "Pippo", cognome: "Baudo")
        def doc2 = new CivVisualizzazioneDocumentiUscita(nome: "Pippo")
        def doc3 = new CivVisualizzazioneDocumentiUscita(cognome: "Baudo")
        def doc4 = new CivVisualizzazioneDocumentiUscita()

        then:
        doc1.getNominativo() == "Baudo Pippo"
        doc2.getNominativo() == "Pippo"
        doc3.getNominativo() == "Baudo"
        doc4.getNominativo() == ""
    }

}
