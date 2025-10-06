package it.finmatica.de4gsdzk.pagamento.nextstep

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.pagamento.IWspaVoceCostoService
import it.finmatica.de4gsdzk.pagamento.WspaVoceCosto
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneErroreException
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneNessunElementoException
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepVoceCostoRepository
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class NextStepVoceCostoService implements IWspaVoceCostoService {
    private final NextStepVoceCostoRepository nextStepVoceCostoRepository
    private final StatoCivileService statoCivileService

    NextStepVoceCostoService(NextStepVoceCostoRepository nextStepVoceCostoRepository, StatoCivileService statoCivileService) {
        this.nextStepVoceCostoRepository = nextStepVoceCostoRepository
        this.statoCivileService = statoCivileService
    }

    @Override
    NextStepVoceCosto create() {
        return new NextStepVoceCosto()
    }

    @Override
    void sincronizza() {
        Integer ret
        try {
            ret = statoCivileService.popolaVociCostoWspa()
        } catch (De4gsdzkRuntimeException e) {
            log.error(e.message, e)
            throw new SincronizzazioneErroreException()
        }
        log.info("Sincronizzazione completata con esito: " + ret)
        if (ret == 0) {
            throw new SincronizzazioneNessunElementoException()
        }
        if (ret < 0) {
            throw new SincronizzazioneErroreException()
        }
    }

    @Override
    NextStepVoceCosto get(Long id) {
        return nextStepVoceCostoRepository.findById(id)
    }

    @Override
    Page<NextStepVoceCosto> listAllByDescrizioneLike(String parametroLike, PageRequest p) {
        return nextStepVoceCostoRepository.findAllByTariffaDirittoDescrizioneLikeIgnoreCase(TestoUtils.isVuoto(parametroLike) ? '%' : parametroLike, p)
    }

    @Override
    NextStepVoceCosto save(WspaVoceCosto obj) {
        return nextStepVoceCostoRepository.save(obj as NextStepVoceCosto)
    }

    @Override
    void delete(WspaVoceCosto obj) {
        nextStepVoceCostoRepository.delete(obj as NextStepVoceCosto)
    }
}
