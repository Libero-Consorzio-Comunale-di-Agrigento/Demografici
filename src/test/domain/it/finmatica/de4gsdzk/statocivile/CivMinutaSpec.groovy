package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.TipoAttoUtils
import spock.lang.Specification

class CivMinutaSpec extends Specification {

    void "getTipoAtto: Istanzia il ETipoAtto in base al valore sul DB"() {
        setup:
        def attesi =  [
                ETipoAtto.CIT, ETipoAtto.NAS, ETipoAtto.PUB,
                ETipoAtto.MAT, ETipoAtto.MOR, ETipoAtto.UCI
        ]
        def tipiAtto = [1,2,3,4,5,-4]

        when:
        List<CivMinuta> minute = []
        for (int i in tipiAtto)
            minute.add(new CivMinuta(tipoAtto: i))

        then:
        def attuali = minute.collect {it -> TipoAttoUtils.fromValoreDefault(it.tipoAtto)}
        attuali == attesi
    }

}
