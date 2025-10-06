package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.AbstractServiceSpec
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivMinutaRepository
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.TestoUtils

class CivMinutaServiceSpec extends AbstractServiceSpec<CivMinuta> {

    CivMinutaService service
    GsdValidazioneTestoService gsdValidazioneTestoService

    void setup() {

        def repo = Mock(CivMinutaRepository)
        repo.findById(_) >> { Long id -> new CivMinuta(id: id, tipoAtto: 2, codice: 99, testo: new CivTestoMinuta()) }
        repo.countByTipoAttoAndCodice(_,_) >> { Integer tipoAtto, Integer codice -> if (codice.intValue() == 98) 0 else 1 }
        repo.save(_) >> { CivMinuta minuta -> duplica(minuta) }
        gsdValidazioneTestoService = new GsdValidazioneTestoService()
        service = new CivMinutaService(
                repo,
                statoCivileService,
                gsdValidazioneTestoService)
    }

    void 'get: deve restituire una CivMinuta in base all\'id' () {
        when:
        CivMinuta m1 = service.get(10)
        CivMinuta m2 = service.get(100)

        then:
        m1.id == 10
        m2.id == 100
    }

    void 'save: Il salvataggio fallisce perche la minuta non contiene il tipoAtto o il codice'() {
        setup:
        CivMinuta sbagliata = new CivMinuta(id: 10, testo: new CivTestoMinuta(id: 99, clob: 'Prova di testo'))

        when:
        service.save(ETipoOperazione.UPD, sbagliata)

        then:
        thrown(CampoMandatoryRuntimeException)
    }

    void 'save: Nuova minuta: il salvataggio fallisce perche la minuta non ha il testo settato'() {
        setup:
        CivMinuta senzaTesto = new CivMinuta(tipoAtto: 2, codice: 98)

        when:
        service.save(ETipoOperazione.INS, senzaTesto)

        then:
        thrown(NullPointerException)
    }

    void 'save: Nuova minuta: il salvataggio ha successo e il campo id è valorizzato automaticamente'() {
        setup:
        CivMinuta nuova = new CivMinuta(tipoAtto: 2, codice: 98, testo: new CivTestoMinuta())

        when:
        service.save(ETipoOperazione.INS, nuova)

        then:
        nuova.id > 0
        nuova.testo.id > 0
    }

    void 'save: Nuova minuta: il salvataggio fallisce se si tenta di inserire una minuta con stesso tipo atto e stesso cod_mi di una gia in archivio'() {
        setup:
        CivMinuta nuova = new CivMinuta(tipoAtto: 2, codice: 99, testo: new CivTestoMinuta())

        when:
        service.save(ETipoOperazione.INS, nuova)

        then:
        thrown(RecordDuplicatoRuntimeException)
    }

    void 'save: Salvataggio minuta esistente'() {

        setup:
        CivMinuta esistente = service.get(10)

        when:
        CivMinuta salvata = service.save(ETipoOperazione.UPD, esistente)

        then:
        esistente != salvata
        esistente.id == salvata.id
    }

    void 'estrazione variabili in minute da testo: caso di successo salvataggio'() {

        setup:
        String testoDiProva = "<ATTO_ORIGINALE> questo testo non dovrebbe essere estratto <COMUNE> <COGNOME_NOME>"
        List<String> listaVariabiliPossibili = ["<ATTO_ORIGINALE>", "<COMUNE>", "<COGNOME_NOME>"]

        when:
        gsdValidazioneTestoService.checkWrongVar(testoDiProva, listaVariabiliPossibili)

        then:
        1 == 1
    }

    void 'estrazione variabili in minute da testo: caso di eccezione (manca la variabile <COMUNE>)'() {

        setup:
        String testoDiProva = "<ATTO_ORIGINALE> questo testo non dovrebbe essere estratto <COMUNE> <COGNOME_NOME>"
        List<String> listaVariabiliPossibili = ["<ATTO_ORIGINALE>", "<COGNOME_NOME>"]

        when:
        gsdValidazioneTestoService.checkWrongVar(testoDiProva, listaVariabiliPossibili)

        then:
        thrown(De4gsdzkRuntimeException)
    }

    void 'estrazione variabili in minute da testo: caso di eccezione (errore su una variabile)'() {

        setup:
        String testoDiProva = "<ATTO_ORIGINALE> questo testo non dovrebbe essere estratto <COMUNE> <COGNO    ME_NOME> , e aggiungo <COMUNe_DI_RESIDENZA>"
        List<String> listaVariabiliPossibili = ["<ATTO_ORIGINALE>", "<COMUNE>", "<COGNOME_NOME>", "<COMUNE_DI_RESIDENZA>"]

        when:
        gsdValidazioneTestoService.checkWrongVar(testoDiProva, listaVariabiliPossibili)

        then:
        thrown(De4gsdzkRuntimeException)
    }

    void 'estrazione variabili in minute da testo: caso di eccezione (mancanza di una parentesi angolare aperta)'() {

        setup:
        String testoDiProva = "<ATTO_ORIGINALE> questo testo non dovrebbe essere estratto <COMUNE> <COGNOME_NOME> , e aggiungo COMUNE_DI_RESIDENZA>"
        List<String> listaVariabiliPossibili = ["<ATTO_ORIGINALE>", "<COMUNE>", "<COGNOME_NOME>"]

        when:
        gsdValidazioneTestoService.checkWrongVar(testoDiProva, listaVariabiliPossibili)

        then:
        thrown(De4gsdzkRuntimeException)
    }

    void 'estrazione variabili in minute da testo: caso 2 di eccezione (mancanza di una parentesi angolare aperta)'() {

        setup:
        String testoDiProva = "test ATTO_ORIGINALE> questo testo non dovrebbe essere estratto <COMUNE> <COGNOME_NOME> , e aggiungo <COMUNE_DI_RESIDENZA>"
        List<String> listaVariabiliPossibili = ["<ATTO_ORIGINALE>", "<COMUNE>", "<COGNOME_NOME>"]

        when:
        gsdValidazioneTestoService.checkWrongVar(testoDiProva, listaVariabiliPossibili)

        then:
        thrown(De4gsdzkRuntimeException)
    }

    void 'estrazione variabili in minute da testo: caso di eccezione (mancanza di una parentesi angolare chiusa)'() {

        setup:
        String testoDiProva = "<ATTO_ORIGINALE> questo testo non dovrebbe essere estratto <COMUNE> <COGNOME_NOME> , e aggiungo <COMUNE_DI_RESIDENZA"
        List<String> listaVariabiliPossibili = ["<ATTO_ORIGINALE>", "<COMUNE>", "<COGNOME_NOME>"]

        when:
        gsdValidazioneTestoService.checkWrongVar(testoDiProva, listaVariabiliPossibili)

        then:
        thrown(De4gsdzkRuntimeException)
    }

    void 'estrazione variabili in minute da testo: caso 2 di eccezione (mancanza di una parentesi angolare chiusa)'() {

        setup:
        String testoDiProva = "<ATTO_ORIGINALE> questo testo non dovrebbe essere estratto <COMUNE> <COGNOME_NOME> , e aggiungo <COMUNE_DI_RESIDENZA test"
        List<String> listaVariabiliPossibili = ["<ATTO_ORIGINALE>", "<COMUNE>", "<COGNOME_NOME>"]

        when:
        gsdValidazioneTestoService.checkWrongVar(testoDiProva, listaVariabiliPossibili)

        then:
        thrown(De4gsdzkRuntimeException)
    }
}
