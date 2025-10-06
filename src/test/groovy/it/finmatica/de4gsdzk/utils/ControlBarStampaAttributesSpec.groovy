package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import spock.lang.Specification

class ControlBarStampaAttributesSpec extends Specification {

    void 'Inizializzazione controlBarStampa ha i valori corretti'() {
        given:
        ControlBarStampaAttributes cb = new ControlBarStampaAttributes()

        expect:
        !cb.excelExportEnabled
        !cb.csvExportEnabled
        !cb.pdfExportEnabled
        !cb.xmlExportEnabled
        !cb.selectStampaEnabled
    }
}
