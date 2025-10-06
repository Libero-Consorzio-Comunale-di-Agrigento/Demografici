package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.AbstractServiceSpec
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneFormulaRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest

class CivComunicazioneFormulaServiceSpec extends AbstractServiceSpec<CivComunicazioneFormula> {

    CivComunicazioneFormulaService service

    PageRequest pr
    Page p1, pALL

    void setup() {
        def repo = Mock(CivComunicazioneFormulaRepository)
        repo.findAllByComunicazioneAndFormulaLike(_, _, _) >> {
            CivComunicazione comunicazione, String s, PageRequest pr -> comunicazione.id!=null ? p1 : pALL
        }

        service = new CivComunicazioneFormulaService(
                repo, statoCivileService, Mock(CivComunicazioneAttoService)
        )

        p1 = Mock(Page)
        p1.getTotalElements() >> {1}
        pALL = Mock(Page)
        pALL.getTotalElements() >> {12}
        pr = new PageRequest(0, 10)
    }

    void 'listAllByComunicazione: se la comunicazione è null restituisce null'() {

        when:
        def listaVuota= service.listAllByComunicazione(null, pr)
        def listaPiena= service.listAllByComunicazione(new CivComunicazione(id: 10), pr)

        then:
        listaVuota == null
        listaPiena.getTotalElements() > 0

    }

    void 'listAllByComunicazione: se la comunicazione ha id nullo restituisce tutte le formule'() {

        when:
        def listaPiena= service.listAllByComunicazione(new CivComunicazione(), pr)

        then:
        listaPiena.getTotalElements() == 12

    }

}
