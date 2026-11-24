package it.finmatica.de4gsdzk.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.error.InvioPagamentoRuntimeException
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.Funzioni
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest

@Slf4j
abstract class WspaPagamentoInviatoService {

    protected final GsdService gsdService
    protected final UtenteCustomService utenteCustomService
    private final WspaPagamentoInviatoRepository wspaPagamentoInviatoRepository

    WspaPagamentoInviatoService(GsdService gsdService,
                                UtenteCustomService utenteCustomService,
                                WspaPagamentoInviatoRepository wspaPagamentoInviatoRepository) {
        this.gsdService = gsdService
        this.utenteCustomService = utenteCustomService
        this.wspaPagamentoInviatoRepository = wspaPagamentoInviatoRepository
    }

    WspaPagamentoInviato findByAnnoAndProgressivo(Integer anno, Integer progressivo) {
        wspaPagamentoInviatoRepository.findByAnnoAndProgressivo(anno, progressivo)
    }

    Page<WspaPagamentoInviato> listAll(RicercaPagamentoInviato r, PageRequest pageRequest) {
        return wspaPagamentoInviatoRepository.findAll(r, pageRequest)
    }

    abstract String getUrl(WspaPagamentoInviato wspaPagamentoInviato)

    abstract Funzioni<EFunzionePagamentoInviato> getFunzioniPagamentoInviato(WspaPagamentoInviato wspaPagamentoInviato)

    void inviaPagamento(WspaPagamentoInviato wspaPagamentoInviato) {
        try {
            String response = gsdService.invioPagamentoWspa(wspaPagamentoInviato.anno, wspaPagamentoInviato.progressivo, utenteCustomService.loggedUserId)
            if (!TestoUtils.isVuoto(response)) {
                throw new InvioPagamentoRuntimeException(response)
            }
        } catch (De4gsdzkRuntimeException ex) {
            log.error(ex.getMessage(), ex)
            throw (ex instanceof InvioPagamentoRuntimeException)
                    ? ex
                    : new InvioPagamentoRuntimeException(ex.getMessage())
        }
    }

    abstract void verificaPagamento(WspaPagamentoInviato wspaPagamentoInviato)

    abstract void annullaPagamento(WspaPagamentoInviato wspaPagamentoInviato)
}