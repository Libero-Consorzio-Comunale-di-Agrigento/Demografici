package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.AbstractServiceSpec
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazioneRepository
import it.finmatica.de4gsdzk.utils.ETipoAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoOperazione

class CivFormulaAnnotazioneServiceSpec extends AbstractServiceSpec<CivFormulaAnnotazione> {

    CivFormulaAnnotazioneService service

    void setup() {
        def repo = Mock(CivFormulaAnnotazioneRepository)
        repo.findById(_) >> { String id -> new CivFormulaAnnotazione(
                id: id, descrizione: 'Descrizione', testo: new CivTestoFormula(id: id))
        }

        service = new CivFormulaAnnotazioneService(
                repo, statoCivileService,
                Mock(CivNotaFormulaService), Mock(CivTestoFormulaService), Mock(ArcParametroService), Mock(GsdValidazioneTestoService))
    }

    void "save: senza id il salvataggio fallisce"() {
        given:
        CivFormulaAnnotazione fa = new CivFormulaAnnotazione(tipoAtto: 2, tipoAnnotazione: ETipoAnnotazione.A)

        when:
        service.save(ETipoOperazione.INS, fa, [])

        then:
        thrown(CampoMandatoryRuntimeException)
    }

    void "save: senza il tipo atto il salvataggio fallisce"() {
        given:
        CivFormulaAnnotazione fa = new CivFormulaAnnotazione(id:"Test", tipoAnnotazione: ETipoAnnotazione.A)

        when:
        service.save(ETipoOperazione.INS, fa, [])

        then:
        thrown(CampoMandatoryRuntimeException)
    }

    void "save: senza il tipo annotazione il salvataggio fallisce"() {
        given:
        CivFormulaAnnotazione fa = new CivFormulaAnnotazione(id:"Test", tipoAtto: 2)

        when:
        service.save(ETipoOperazione.INS, fa, [])

        then:
        thrown(CampoMandatoryRuntimeException)
    }

    //TODO
    void todo_test() {
        when:
        def formula = service.get("F1")
        then:
        formula.id == "F1"
    }

}
