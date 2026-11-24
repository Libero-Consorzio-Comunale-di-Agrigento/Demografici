package it.finmatica.de4gsdzk.pagamento.nextstep

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviare
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviareService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.certificazione.RicercaCertificato
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class NextStepPagamentoDaInviareService extends WspaPagamentoDaInviareService {

    private final NextStepPagamentoDaInviareRepository nextStepPagamentoDaInviareRepository

    NextStepPagamentoDaInviareService(GsdService gsdService,
                                      UtenteCustomService utenteCustomService,
                                      NextStepPagamentoDaInviareRepository nextStepPagamentoDaInviareRepository
    ) {
        super(gsdService, utenteCustomService)
        this.nextStepPagamentoDaInviareRepository = nextStepPagamentoDaInviareRepository
    }

    @Override
    Page<WspaPagamentoDaInviare> listAll(RicercaCertificato r, PageRequest pageRequest) {
        return nextStepPagamentoDaInviareRepository.findAllByRicercaCertificato(r, pageRequest)
    }

    @Override
    void saveAll(Collection<WspaPagamentoDaInviare> pagamentiDaInviare) {
        nextStepPagamentoDaInviareRepository.save(pagamentiDaInviare as Collection<NextStepPagamentoDaInviare>)
    }

    @Override
    void validaInvioPagamento(Collection<WspaPagamentoDaInviare> collection) {
    }
}
