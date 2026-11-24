package it.finmatica.de4gsdzk.pagamento.depag

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.EFunzionePagamentoInviato
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviato
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviatoService
import it.finmatica.de4gsdzk.pagamento.error.AnnullaPagamentoRuntimeException
import it.finmatica.de4gsdzk.pagamento.error.VerificaPagamentoRuntimeException
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviatoRepository
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.Funzioni
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class DepagPagamentoInviatoService extends WspaPagamentoInviatoService {

    DepagPagamentoInviatoService(GsdService gsdService,
                                 UtenteCustomService utenteCustomService,
                                 WspaPagamentoInviatoRepository wspaPagamentoInviatoRepository) {
        super(gsdService, utenteCustomService, wspaPagamentoInviatoRepository)
    }

    @Override
    String getUrl(WspaPagamentoInviato wspaPagamentoInviato) {
        return gsdService.getUrlWspa(wspaPagamentoInviato.chiaveServizioEsterno)
    }

    @Override
    Funzioni<EFunzionePagamentoInviato> getFunzioniPagamentoInviato(WspaPagamentoInviato pagamentoInviato) {
        Funzioni<EFunzionePagamentoInviato> funzioni = new Funzioni<EFunzionePagamentoInviato>()
        if(pagamentoInviato == null){
            return funzioni
        }

        EFunzionePagamentoInviato.values().each {
            switch (it) {
                case EFunzionePagamentoInviato.RIPETIZIONE:
                    funzioni.set(EFunzionePagamentoInviato.RIPETIZIONE, !pagamentoInviato.isInviatoConSuccesso(), true)
                    break
                case EFunzionePagamentoInviato.CONFERMA:
                    funzioni.set(EFunzionePagamentoInviato.CONFERMA, pagamentoInviato.isInviatoConSuccesso(), true)
                    break
                case EFunzionePagamentoInviato.VERIFICA:
                    funzioni.set(EFunzionePagamentoInviato.VERIFICA, false, false)
                    break
                case EFunzionePagamentoInviato.ANNULLA:
                    funzioni.set(EFunzionePagamentoInviato.ANNULLA, pagamentoInviato.isInviatoConSuccesso(), true)
                    break
                default:
                    funzioni.set(it, false, true)
                    break
            }
        }
        return funzioni
    }

    @Override
    void verificaPagamento(WspaPagamentoInviato wspaPagamentoInviato) {
        try {
            String response = gsdService.verificaPagamentoWspa(wspaPagamentoInviato.chiaveServizioEsterno, utenteCustomService.loggedUserId)
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

    @Override
    void annullaPagamento(WspaPagamentoInviato wspaPagamentoInviato) {
        try {
            String response = gsdService.annullaPagamentoWspa(wspaPagamentoInviato.chiaveServizioEsterno, utenteCustomService.loggedUserId)
            if (!TestoUtils.isVuoto(response)) {
                throw new AnnullaPagamentoRuntimeException(response)
            }
        } catch (De4gsdzkRuntimeException ex) {
            log.error(ex.getMessage(), ex)
            throw (ex instanceof AnnullaPagamentoRuntimeException)
                    ? ex
                    : new AnnullaPagamentoRuntimeException(ex.getMessage())
        }
    }
}
