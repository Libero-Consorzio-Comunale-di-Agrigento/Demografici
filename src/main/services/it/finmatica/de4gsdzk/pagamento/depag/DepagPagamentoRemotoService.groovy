package it.finmatica.de4gsdzk.pagamento.depag

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.error.VerificaPagamentoRuntimeException
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class DepagPagamentoRemotoService {
    private final DepagPagamentoRemotoRepository depagPagamentoRemotoRepository
    private final GsdService gsdService
    private final UtenteCustomService utenteCustomService

    DepagPagamentoRemotoService(DepagPagamentoRemotoRepository depagPagamentoRemotoRepository,
                                GsdService gsdService,
                                UtenteCustomService utenteCustomService) {
        this.depagPagamentoRemotoRepository = depagPagamentoRemotoRepository
        this.gsdService = gsdService
        this.utenteCustomService = utenteCustomService
    }


    DepagPagamentoRemoto findById(String chiaveServizioEsterno) {
        return depagPagamentoRemotoRepository.findById(chiaveServizioEsterno)
    }

    void verificaPagamento(String chiaveServizioEsterno) {
        try {
            String response = gsdService.verificaPagamentoWspa(chiaveServizioEsterno, utenteCustomService.loggedUserId)
            if (!TestoUtils.isVuoto(response)) {
                throw new VerificaPagamentoRuntimeException(response)
            }
        } catch (De4gsdzkRuntimeException ex) {
            log.error(ex.getMessage(), ex)
            throw (ex instanceof VerificaPagamentoRuntimeException)
                    ? ex
                    : new VerificaPagamentoRuntimeException(ex.getMessage())
        }
    }

}
