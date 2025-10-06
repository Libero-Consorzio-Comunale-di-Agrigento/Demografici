package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.controlbar.ControlBarFascicoloAttributes
import spock.lang.Specification

class ControlBarFascicoloAttributesSpec extends Specification {
    void 'Inizializzazione controlBarFascicolo ha i valori corretti'() {
        given:
        ControlBarFascicoloAttributes cb = new ControlBarFascicoloAttributes()

        expect:
        !cb.backFromListFascicoloEnabled
        !cb.pagingFascicoloEnabled
        cb.additionalFascicoloSearchFilter == ""
        !cb.uploadFascicoloEnabled
        !cb.scansionaEnabled
        !cb.importaDaProtocolloEnabled
        !cb.deleteFascicoloEnabled
    }
}
