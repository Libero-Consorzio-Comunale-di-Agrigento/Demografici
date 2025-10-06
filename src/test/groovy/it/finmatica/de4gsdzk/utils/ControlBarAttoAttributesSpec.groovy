package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAttoAttributes
import spock.lang.Specification

class ControlBarAttoAttributesSpec extends Specification {

    void 'Inizializzazione controlBarAtto ha i valori corretti'() {
        given:
        ControlBarAttoAttributes cb = new ControlBarAttoAttributes()

        expect:
        cb.annotazioniEnabled
        !cb.anscEnabled
    }
}
