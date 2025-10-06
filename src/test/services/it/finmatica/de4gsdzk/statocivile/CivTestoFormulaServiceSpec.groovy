package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.AbstractServiceSpec
import it.finmatica.de4gsdzk.statocivile.CivTestoFormulaRepository
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException

class CivTestoFormulaServiceSpec extends AbstractServiceSpec<CivTestoFormula> {

    CivTestoFormulaService service

    void setup() {
        def repo = Mock(CivTestoFormulaRepository)
        repo.findById(_) >> { String id -> new CivTestoFormula(
                id: id, testoA4: 'Testo')}

        service = new CivTestoFormulaService(repo)
    }

    void "save: senza id il salvataggio fallisce"() {
        given:
        def testo = new CivTestoFormula(testoA4: "Testo A4")

        when:
        service.save(testo)

        then:
        thrown(De4gsdzkRuntimeException)
    }



}
