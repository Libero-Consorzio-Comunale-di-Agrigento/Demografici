package it.finmatica.de4gsdzk.utils

import spock.lang.Specification

class IProgressivoSpec extends Specification {
    void "Oggetto Progressivo ha anno e numero"() {
        when:
        IProgressivo progressivo = new IProgressivo() {
            Integer anno = 1997
            Long numero = 620
        }

        then:
        progressivo.anno == 1997
        progressivo.numero == 620
    }
}
