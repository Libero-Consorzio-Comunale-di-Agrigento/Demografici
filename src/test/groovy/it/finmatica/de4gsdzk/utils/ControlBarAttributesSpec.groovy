package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAttributes
import spock.lang.Specification

class ControlBarAttributesSpec extends Specification {
    void 'Inizializzazione controlBarAttributes ha i valori corretti'() {
        given:
        ControlBarAttributes cb = new ControlBarAttributes()

        expect:
        cb.backEnabled

        cb.pagingEnabled
        !cb.searchEnabled
        !cb.searchPopupEnabled

        cb.additionalSearchFilter == ""
        cb.additionalSearchFilter2 == ""

        !cb.saveEnabled
        cb.addEnabled
        cb.modifyEnabled
        !cb.deleteEnabled

        !cb.addPlusEnabled
        !cb.addCustomEnabled

        !cb.excelExportEnabled
        !cb.csvExportEnabled
        !cb.pdfExportEnabled
        !cb.xmlExportEnabled

        !cb.filtriExtraEnabled

        !cb.printEnabled
        !cb.printPlusEnabled

        cb.additionalToolbarbutton == null
        cb.additionalToolbarbutton2 == null
        cb.additionalToolbarbutton3 == null
    }
}
