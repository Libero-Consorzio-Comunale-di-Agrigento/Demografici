package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import spock.lang.Specification

class ControlBarDettaglioAttributesSpec extends Specification {

    void 'Inizializzazione controlBarDettaglio ha i valori corretti'() {
        given:
        ControlBarDettaglioAttributes cb = new ControlBarDettaglioAttributes()

        expect:
        !cb.saveRecordEnabled
        cb.backFromRecordEnabled
        !cb.printRecordEnabled
        !cb.deleteRecordEnabled
        !cb.printRecordPlusEnabled
    }
}
