package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAnnotazioniAttributes
import spock.lang.Specification

class ControlBarAnnotazioniAttributesSpec extends Specification {

    void 'Inizializzazione controlBarAnnotazioni ha i valori corretti'() {
        given:
        ControlBarAnnotazioniAttributes cb = new ControlBarAnnotazioniAttributes()

        expect:
        !cb.backFromListAnnotazioneEnabled
        !cb.backFromRecordAnnotazioneEnabled
        !cb.pagingAnnotazioneEnabled
        !cb.searchAnnotazioneEnabled
        !cb.selectTipoOrdinamentoEnabled
        !cb.goToComunicazioniEnabled
        cb.addAnnotazioneEnabled
        !cb.addPlusAnnotazioneEnabled
        cb.modifyAnnotazioneEnabled
        !cb.deleteAnnotazioneEnabled
        !cb.saveRecordAnnotazioneEnabled
        cb.additionalListaToolbarbutton == null
        cb.additionalListaToolbarbutton2 == null
        cb.additionalListaToolbarbutton3 == null
    }
}
