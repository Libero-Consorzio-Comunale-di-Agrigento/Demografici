package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.utils.controlbar.ControlBarComunicazioniAttributes
import spock.lang.Specification

class ControlBarComunicazioniAttributesSpec extends Specification {

    void 'Inizializzazione controlBarComunicazioni ha i valori corretti'() {
        given:
        ControlBarComunicazioniAttributes cb = new ControlBarComunicazioniAttributes()

        expect:
        !cb.backFromListComunicazioneEnabled
        !cb.pagingComunicazioneEnabled
        !cb.addComunicazioneEnabled
        !cb.generaTestoComunicazioneEnabled
        !cb.protocollaComunicazioneEnabled
        !cb.sendAlboComunicazioneEnabled
        !cb.goToFascicoloEnabled
    }
}
