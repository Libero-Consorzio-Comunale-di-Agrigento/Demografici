package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import spock.lang.Specification
import spock.lang.Unroll

class TipoAttoUtilsSpec extends Specification {

    //PVU non viene riconosciuto perché ha lo stesso valore di CIT
    void "Istanzia un ETipoAtto in base al valore sul DB"() {

        setup:
        def attesi = [
                ETipoAtto.CIT, ETipoAtto.NAS, ETipoAtto.PUB, ETipoAtto.MAT, ETipoAtto.MOR
        ].toArray()
        def attuali = new ETipoAtto[5]

        when:
        for (int i=0; i<5; i++)
            attuali[i] = TipoAttoUtils.fromValore(i+1)

        then:
        attuali == attesi
    }

    void "Istanzia un ETipoAtto in base a un valore ambiguo sul DB"() {
        when:
        TipoAttoUtils.fromValore(-4)

        then:
        def e = thrown(IllegalArgumentException)
        e.getMessage() == "Valore ETipoAtto ambiguo: -4"
    }

    void "Istanzia un ETipoAtto in base a un valore non presente sul DB"() {
        when:
        TipoAttoUtils.fromValore(42)

        then:
        def e = thrown(IllegalArgumentException)
        e.getMessage() == "Valore ETipoAtto non riconosciuto: 42"
    }

    @Unroll
    def "isAttoOk(#input) should return #expected"() {
        expect:
        TipoAttoUtils.isAttoOk(input, optional) == expected

        where:
        input | optional | expected
        null  | true     | true
        null  | false    | false
        9999  | true     | true
        10000 | true     | false
        15000 | true     | false
    }

    @Unroll
    def "isAnnoOk(#input) should return #expected"() {
        expect:
        TipoAttoUtils.isAnnoOk(input, optional) == expected

        where:
        input | optional | expected
        null  | true     | true
        null  | false    | false
        1799  | true     | false
        1800  | true     | true
        2024  | true     | true
        10000 | true     | false
    }

    @Unroll
    def "isParteOk(#tipoAtto, #parte) should return #expected"() {
        expect:
        TipoAttoUtils.isParteOk(tipoAtto, parte, optional) == expected

        where:
        tipoAtto      | parte | optional | expected
        ETipoAtto.NAS | null  | true     | true
        ETipoAtto.NAS | null  | false    | false
        ETipoAtto.NAS | 1     | true     | true
        ETipoAtto.NAS | 2     | true     | true
        ETipoAtto.NAS | 3     | true     | false
        ETipoAtto.MAT | null  | true     | true
        ETipoAtto.MAT | null  | false    | false
        ETipoAtto.MAT | 1     | true     | true
        ETipoAtto.MAT | 2     | true     | true
        ETipoAtto.MAT | 3     | true     | false
        ETipoAtto.MOR | null  | true     | true
        ETipoAtto.MOR | null  | false    | false
        ETipoAtto.MOR | 1     | true     | true
        ETipoAtto.MOR | 2     | true     | true
        ETipoAtto.MOR | 3     | true     | false
        ETipoAtto.UCI | null  | true     | true
        ETipoAtto.UCI | null  | false    | true
        ETipoAtto.UCI | 1     | true     | true
        ETipoAtto.UCI | 2     | true     | true
        ETipoAtto.UCI | 3     | true     | false
    }

    @Unroll
    def "isSerieOk(#tipoAtto, #serie) should return #expected"() {
        expect:
        TipoAttoUtils.isSerieOk(tipoAtto, serie) == expected

        where:
        tipoAtto      | serie                 | expected
        ETipoAtto.NAS | null                  | true
        ETipoAtto.NAS | ""                    | true
        ETipoAtto.NAS | CivTipoAtto.SERIE_A   | true
        ETipoAtto.NAS | CivTipoAtto.SERIE_B   | true
        ETipoAtto.NAS | CivTipoAtto.SERIE_C   | false
        ETipoAtto.NAS | CivTipoAtto.SERIE_BIS | false
        ETipoAtto.NAS | "XXX"                 | false

        ETipoAtto.MAT | null                  | true
        ETipoAtto.MAT | ""                    | true
        ETipoAtto.MAT | CivTipoAtto.SERIE_A   | true
        ETipoAtto.MAT | CivTipoAtto.SERIE_B   | true
        ETipoAtto.MAT | CivTipoAtto.SERIE_C   | true
        ETipoAtto.MAT | CivTipoAtto.SERIE_BIS | false
        ETipoAtto.MAT | "XXX"                 | false

        ETipoAtto.MOR | null                  | true
        ETipoAtto.MOR | ""                    | true
        ETipoAtto.MOR | CivTipoAtto.SERIE_A   | true
        ETipoAtto.MOR | CivTipoAtto.SERIE_B   | true
        ETipoAtto.MOR | CivTipoAtto.SERIE_C   | true
        ETipoAtto.MOR | CivTipoAtto.SERIE_BIS | true
        ETipoAtto.MOR | "XXX"                 | false
    }

}
