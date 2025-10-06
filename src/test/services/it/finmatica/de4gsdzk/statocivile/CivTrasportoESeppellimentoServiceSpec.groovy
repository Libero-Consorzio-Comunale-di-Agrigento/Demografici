package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.AbstractServiceSpec
import it.finmatica.de4gsdzk.errors.ErroreProtocollazioneRuntimeException
import it.finmatica.de4gsdzk.errors.NumeroProtocolloException
import it.finmatica.de4gsdzk.statocivile.CivNumerazioneDocumentiUscitaRepository
import it.finmatica.de4gsdzk.statocivile.CivTrasportoESeppellimentoRepository
import it.finmatica.de4gsdzk.utils.ETipoSiNo

class CivTrasportoESeppellimentoServiceSpec extends AbstractServiceSpec<CivTrasportoESeppellimento> {

    CivTrasportoESeppellimentoService service

    def valoriAtto = [ufficio: 1, anno: 2020, atto: 10, serie: "A", parte: 1]

    void setup() {
        //mock repo
        def repo = Mock(CivTrasportoESeppellimentoRepository)
        repo.save(_) >> {CivTrasportoESeppellimento obj -> duplica(obj)}
        repo.findAllByIdNotAndRegistroTrasportoAndAnnoProtocolloTrasportoAndNumeroProtocolloTrasporto(_,_,_,_) >>
                { Long id, CivRegistroDocumentiUscita registro, Integer anno, Integer number -> id==1 ? [new CivTrasportoESeppellimento(id:99999)] : []}

        //mock repo numerazione
        def numerazioneRepo = Mock(CivNumerazioneDocumentiUscitaRepository)
        //service numerazione
        def numerazioneService = new CivNumerazioneDocumentiUscitaService(numerazioneRepo, statoCivileService)
        //service
        service = new CivTrasportoESeppellimentoService(repo, numerazioneService, statoCivileService)
    }

    void "save: cancella il record se trasporto e cremazione non sono settati"() {

        given:
        CivTrasportoESeppellimento c = new CivTrasportoESeppellimento(valoriAtto)

        when:
        Map<String, CivNumerazioneDocumentiUscita> nduMap = [:]
        nduMap.put(CivTipoRegistro.ID_TRASPORTO, null)
        nduMap.put(CivTipoRegistro.ID_SEPPELLIMENTO, null)
        nduMap.put(CivTipoRegistro.ID_CREMAZIONE, null)
        def saved = service.save(c, nduMap, Boolean.FALSE)

        then:
        saved==null
    }

    void "save: lancia eccezione se trasporto e cremazione hanno stesso registro e anno protocollo ma numero diverso"() {

        given:
        CivTrasportoESeppellimento c = new CivTrasportoESeppellimento(valoriAtto + [
                trasporto: ETipoSiNo.SI])
        CivNumerazioneDocumentiUscita tr = new CivNumerazioneDocumentiUscita(
                anno: 2021, numero: 5, registro: new CivRegistroDocumentiUscita(id: 10))
        CivNumerazioneDocumentiUscita cr = new CivNumerazioneDocumentiUscita(
                anno: 2021, numero: 6, registro: new CivRegistroDocumentiUscita(id: 10))

        when:
        Map<String, CivNumerazioneDocumentiUscita> nduMap = [:]
        nduMap.put(CivTipoRegistro.ID_TRASPORTO, tr)
        nduMap.put(CivTipoRegistro.ID_SEPPELLIMENTO, null)
        nduMap.put(CivTipoRegistro.ID_CREMAZIONE, cr)
        service.save(c, nduMap, Boolean.FALSE)

        then:
        String msg = thrown(ErroreProtocollazioneRuntimeException)
        System.out.println("ERR: " + msg)
    }

    void "save: lancia l'eccezione se il numero si trova già in un altro record"() {
        given:
        CivTrasportoESeppellimento c = new CivTrasportoESeppellimento([
                 id: 1,
                 numeroProtocolloTrasporto: 5,
                 annoProtocolloTrasporto: 2021,
                 registroTrasporto: new CivRegistroDocumentiUscita(id: 10),
                 trasporto: ETipoSiNo.SI] + valoriAtto)

        when:
        Map<String, CivNumerazioneDocumentiUscita> nduMap = [:]
        nduMap.put(CivTipoRegistro.ID_TRASPORTO, null)
        nduMap.put(CivTipoRegistro.ID_SEPPELLIMENTO, null)
        nduMap.put(CivTipoRegistro.ID_CREMAZIONE, null)
        service.save(c, nduMap, Boolean.FALSE)

        then:
        String msg = thrown(NumeroProtocolloException)
        System.out.println("ERR: " + msg)
        /*
        when:
        c.id=2
        def saved = service.save(c, nduMap, Boolean.FALSE)

        then:
        saved.id == 2
        */
     }

}
