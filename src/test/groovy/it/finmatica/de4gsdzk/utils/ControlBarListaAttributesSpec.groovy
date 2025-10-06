package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import spock.lang.Specification

class ControlBarListaAttributesSpec extends Specification {

    void 'Inizializzazione controlBarLista ha i valori corretti'() {
        given:
        ControlBarListaAttributes cb = new ControlBarListaAttributes()

        expect:
        cb.pagingEnabled
        !cb.searchEnabled
        !cb.searchPopupEnabled
        cb.additionalSearchFilter == ""
        cb.additionalSearchFilter2 == ""
        cb.additionalListaToolbarbutton == null
        cb.modifyEnabled
        cb.addEnabled
        !cb.addPlusEnabled
        !cb.addCustomEnabled
        !cb.deleteEnabled
        !cb.excelExportEnabled
        !cb.csvExportEnabled
        !cb.printEnabled
        !cb.printPlusEnabled
        !cb.filtriExtraEnabled
    }
}
