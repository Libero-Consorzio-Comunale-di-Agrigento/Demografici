package it.finmatica.de4gsdzk.pagamento.nextstep

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.EFunzionePagamentoInviato
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviato
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviatoService
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviatoRepository
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.Funzioni
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class NextStepPagamentoInviatoService extends WspaPagamentoInviatoService {

    NextStepPagamentoInviatoService(StatoCivileService statoCivileService,
                                    UtenteCustomService utenteCustomService,
                                    WspaPagamentoInviatoRepository wspaPagamentoInviatoRepository) {
        super(statoCivileService, utenteCustomService, wspaPagamentoInviatoRepository)
    }

    @Override
    String getUrl(WspaPagamentoInviato wspaPagamentoInviato) {
        return wspaPagamentoInviato.urlServizioEsterno
    }

    @Override
    Funzioni<EFunzionePagamentoInviato> getFunzioniPagamentoInviato(WspaPagamentoInviato pagamentoInviato) {
        Funzioni<EFunzionePagamentoInviato> funzioni = new Funzioni<EFunzionePagamentoInviato>()
        EFunzionePagamentoInviato.values().each {
            switch (it) {
                case EFunzionePagamentoInviato.CONFERMA:
                    funzioni.set(EFunzionePagamentoInviato.CONFERMA, pagamentoInviato.isInviatoConSuccesso(), true)
                    break
                case EFunzionePagamentoInviato.RIPETIZIONE:
                    funzioni.set(EFunzionePagamentoInviato.RIPETIZIONE, !pagamentoInviato.isInviatoConSuccesso(), true)
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
        throw new IllegalStateException("Impossibile verificare il pagamento con NextStep")
    }

    @Override
    void annullaPagamento(WspaPagamentoInviato wspaPagamentoInviato) {
        throw new IllegalStateException("Impossibile annullare il pagamento con NextStep")
    }
}
