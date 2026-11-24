package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.AbstractServiceSpec
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivNumerazioneDocumentiUscitaRepository

class CivNumerazioneDocumentiUscitaServiceSpec extends AbstractServiceSpec<CivNumerazioneDocumentiUscita> {

    CivNumerazioneDocumentiUscitaService service

    CivRegistroDocumentiUscita registro_11
    CivNumerazioneDocumentiUscita numerazione_2020_11

    void setup() {
        registro_11 = new CivRegistroDocumentiUscita(id: 11)
        numerazione_2020_11 = new CivNumerazioneDocumentiUscita(numero: 1, anno: 2020, registro: registro_11)

        //mock repo
        def repo = Mock(CivNumerazioneDocumentiUscitaRepository)
        repo.save(_) >> { CivNumerazioneDocumentiUscita doc -> duplica(doc) }
        repo.findByAnnoAndRegistro(_, _) >> {Integer anno, CivRegistroDocumentiUscita registro ->
            (anno==2020 && registro.id==11) ? numerazione_2020_11 : null }

        //service
        service = new CivNumerazioneDocumentiUscitaService(
                repo,
                gsdService)


    }

    void 'save: Salvataggio documento incompleto fallisce'() {

        setup:
        CivNumerazioneDocumentiUscita doc1 = new CivNumerazioneDocumentiUscita(
                numero: 10, registro: registro_11)
        CivNumerazioneDocumentiUscita doc2 = new CivNumerazioneDocumentiUscita(
                anno: 2010, registro: registro_11)
        CivNumerazioneDocumentiUscita doc3 = new CivNumerazioneDocumentiUscita(
                anno: 2010, numero: 10, registro: new CivRegistroDocumentiUscita())

        //senza anno
        when:
        service.save(doc1)
        then:
        thrown(CampoMandatoryRuntimeException)

        //senza numero
        when:
        service.save(doc2)
        then:
        thrown(CampoMandatoryRuntimeException)

        //senza id registro
        when:
        service.save(doc2)
        then:
        thrown(CampoMandatoryRuntimeException)

    }

    void 'save: Salvataggio documento completo'() {

        setup:
        CivNumerazioneDocumentiUscita nuovo = new CivNumerazioneDocumentiUscita(
                anno: 2010, numero: 10, registro: registro_11)
        CivNumerazioneDocumentiUscita esistente = new CivNumerazioneDocumentiUscita(
                id: 10, anno: 2010, numero: 10, registro: registro_11)

        when:
        CivNumerazioneDocumentiUscita creato = service.save(nuovo)
        CivNumerazioneDocumentiUscita salvato = service.save(esistente)

        then:
        creato.id > 0
        esistente != salvato
        esistente.id == salvato.id
    }

    void 'getOrCreateByAnnoAndRegistro: crea una nuova numerazione se non esistente'() {
        when:
        def c = service.getOrCreateByAnnoAndRegistro(2022, registro_11)

        then:
        c.numero == 0
    }

    void 'getByAnnoAndRegistro: incrementa il numero di 1 dopo il recupero da db'() {
        when:
        CivNumerazioneDocumentiUscita c = service.getByAnnoAndRegistro(2020, registro_11)
        def max = c.numero + 1

        then:
        max == 2
        //ovvero
        numerazione_2020_11.numero == 1
    }


}
