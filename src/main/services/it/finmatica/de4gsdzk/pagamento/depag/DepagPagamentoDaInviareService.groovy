package it.finmatica.de4gsdzk.pagamento.depag

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviare
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviareService
import it.finmatica.de4gsdzk.pagamento.error.ServizioNonCoerenteRuntimeException
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoDaInviareRepository
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.certificazione.RicercaCertificato
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class DepagPagamentoDaInviareService extends WspaPagamentoDaInviareService {

    DepagPagamentoDaInviareRepository depagPagamentoDaInviareRepository

    DepagPagamentoDaInviareService(StatoCivileService statoCivileService,
                                   UtenteCustomService utenteCustomService,
                                   DepagPagamentoDaInviareRepository depagPagamentoDaInviareRepository) {
        super(statoCivileService, utenteCustomService)
        this.depagPagamentoDaInviareRepository = depagPagamentoDaInviareRepository
    }

    @Override
    Page<WspaPagamentoDaInviare> listAll(RicercaCertificato r, PageRequest pageRequest) {
        return depagPagamentoDaInviareRepository.findAllByRicercaCertificato(r, pageRequest)
    }

    @Override
    void saveAll(Collection<WspaPagamentoDaInviare> pagamentiDaInviare) {
        depagPagamentoDaInviareRepository.save(pagamentiDaInviare as Collection<DepagPagamentoDaInviare>)
    }

    @Override
    void validaInvioPagamento(Collection<WspaPagamentoDaInviare> collection) {
        collection = collection as Collection<DepagPagamentoDaInviare>
        DepagServizio depagServizio = collection.first().servizio
        boolean allSameServizio = collection.every { it.servizio == depagServizio }
        if (!allSameServizio) {
            throw new ServizioNonCoerenteRuntimeException()
        }
    }
}
