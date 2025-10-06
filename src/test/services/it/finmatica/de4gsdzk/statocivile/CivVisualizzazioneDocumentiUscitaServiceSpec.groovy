package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.AbstractServiceSpec
import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiUscitaRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import spock.lang.Specification

class CivVisualizzazioneDocumentiUscitaServiceSpec extends AbstractServiceSpec<CivVisualizzazioneDocumentiUscitaService> {

    CivVisualizzazioneDocumentiUscitaService service

    void setup() {
        def repo = Mock(CivVisualizzazioneDocumentiUscitaRepository)
        def page = Mock(Page)
        def pageNumerati = Mock(Page)
        def pageNonNumerati = Mock(Page)
        pageNumerati.getTotalElements() >> {10}
        pageNonNumerati.getTotalElements() >> {1}
        repo.findAllAnniByIdRegistro(_) >> { [2017, 2021] }
        repo.findAllNonAssociatiByDTS(_, _, _) >> { page }
        repo.findAllAssociatiNumeratiByIdRegistro(_, _, _, _) >> { pageNumerati }
        repo.findAllAssociatiNonNumeratiByIdRegistro(_, _, _, _) >> { pageNonNumerati }

        service = new CivVisualizzazioneDocumentiUscitaService(repo)
    }

    void "listAllAssociatiByRegistro: se registro non e' valorizzato restituisce null"() {

        setup:
        PageRequest pr = new PageRequest(0, Integer.MAX_VALUE)
        CivRegistroDocumentiBaseDomain registro = new CivRegistroDocumentiUscita(id: 11)

        when:
        //associati
        def l1 = service.listAllAssociatiByRegistro(
                null, null, true, null, pr)
        def l2 = service.listAllAssociatiByRegistro(
                registro, null, true, null, pr)
        def l3 = service.listAllAssociatiByRegistro(
                registro, null, false, null, pr)

        then:
        l1 == null
        l2.getTotalElements() == 10
        l3.getTotalElements() == 1

    }

    void "listAllAnniByRegistro: se il registro non e' valorizzato restituisce una lista vuota"() {

        setup:
        CivRegistroDocumentiBaseDomain registro = new CivRegistroDocumentiUscita(id: 11)

        when:
        def l1 = service.listAllAnniByRegistro(null)
        def l2 = service.listAllAnniByRegistro(registro)

        then:
        l1.isEmpty()
        !l2.isEmpty()

    }

}
