package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.AbstractServiceSpec
import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiEntrataRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest

class CivVisualizzazioneDocumentiEntrataServiceSpec extends AbstractServiceSpec<CivVisualizzazioneDocumentiEntrataService> {

    CivVisualizzazioneDocumentiEntrataService service

    void setup() {
        def repo = Mock(CivVisualizzazioneDocumentiEntrataRepository)
        def page = Mock(Page)
        def pageNumerati = Mock(Page)
        def pageNonNumerati = Mock(Page)
        pageNumerati.getTotalElements() >> {10}
        pageNonNumerati.getTotalElements() >> {1}
        repo.findAllNumeratiByIdRegistro(_, _, _, _) >> { pageNumerati }
        repo.findAllNonNumeratiByIdRegistro(_, _, _, _) >> { pageNonNumerati }

        service = new CivVisualizzazioneDocumentiEntrataService(repo)
    }

    void "listAllAssociatiByRegistro: se registro non e' valorizzato restituisce null"() {

        setup:
        PageRequest pr = new PageRequest(0, Integer.MAX_VALUE)
        CivRegistroDocumentiBaseDomain registro = new CivRegistroDocumentiEntrata(id: 11)

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

}
