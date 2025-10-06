package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.controlbar.ControlBarANSCAttributes
import spock.lang.Specification

class ControlBarANSCAttributesSpec extends Specification {

    void 'Inizializzazione controlBarANSC ha i valori corretti'() {
        given:
        ControlBarANSCAttributes cb = new ControlBarANSCAttributes()

        expect:
        !cb.backFromListANSCEnabled
        !cb.goToFascicoloANSCEnabled
        cb.goToAllegatiANSCEnabled
        cb.goToFirmatariANSCEnabled
        !cb.saveANSCEnabled
        !cb.goToANSCEnabled
        cb.goToAllegatiANSCGrayed
    }
}
