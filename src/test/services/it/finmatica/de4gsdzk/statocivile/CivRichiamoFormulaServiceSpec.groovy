package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.AbstractServiceSpec
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivRichiamoFormulaRepository
import it.finmatica.de4gsdzk.statocivile.CivTestoFormulaRepository
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException

class CivRichiamoFormulaServiceSpec extends AbstractServiceSpec<CivRichiamoFormula> {

    CivRichiamoFormulaService service

    CivFormulaAnnotazione formula

    void setup() {

        formula = new CivFormulaAnnotazione(id: '3-FORMULA', testo: new CivTestoFormula(id: '3-FORMULA'))

        def repo = Mock(CivRichiamoFormulaRepository)
        repo.findById(_) >> { Long id -> new CivRichiamoFormula(
                id: id, tipoAtto: 2, richiamo:1, progressivo: 3, formula: formula)
        }
        repo.save(_) >> { CivRichiamoFormula richiamo -> duplica(richiamo) }
        repo.findAllByTipoAttoAndFormula(_, _) >> { int tipoAtto, CivFormulaAnnotazione formula ->
                [new CivRichiamoFormula(
                        id: 2L, tipoAtto: tipoAtto, richiamo: 1,
                        progressivo: new Integer(formula.id.charAt(0).toString()),
                        formula: formula)
                ]
        }

        CivTestoFormulaService civTestoFormulaService = new CivTestoFormulaService(Mock(CivTestoFormulaRepository))

        service = new CivRichiamoFormulaService(
                repo, Mock(GsdValidazioneTestoService), civTestoFormulaService, statoCivileService)

    }

    void "save: Lancia un'eccezione se la formula è già usata per il richiamo corrente"() {

        setup:
        CivRichiamoFormula formula = new CivRichiamoFormula(
                tipoAtto: 2, richiamo:1, progressivo: 3, formula: formula)

        when:
        service.save(formula)

        then:
        def e = thrown(De4gsdzkRuntimeException)
        e instanceof RecordDuplicatoRuntimeException

    }

    void "save: Lancia un'eccezione se la formula è già usata da un'altra parte"() {

        setup:
        CivRichiamoFormula formula = service.get(1L)
        formula.progressivo = 4

        when:
        service.save(formula)

        then:
        def e = thrown(De4gsdzkRuntimeException)
        e instanceof CivRichiamoFormulaService.FormulaUsataException

    }

    void "save: Forza il salvataggio se la formula è già usata da un'altra parte"() {

        setup:
        CivRichiamoFormula formula = service.get(1L)
        formula.progressivo = 4

        when:
        CivRichiamoFormula s = service.save(formula, true)

        then:
        s != formula

    }

    void 'save: Salvataggio documento incompleto fallisce: manca la formula'() {

        setup:
        CivRichiamoFormula formula = new CivRichiamoFormula(id: 10L, tipoAtto: 2, richiamo:1, progressivo: 3)

        when:
        service.save(formula)

        then:
        thrown(CampoMandatoryRuntimeException)

    }

}
