package it.finmatica.de4gsdzk.pagamento.nextstep

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.pagamento.EServizioPagamento
import it.finmatica.de4gsdzk.pagamento.IWspaParametroService
import it.finmatica.de4gsdzk.pagamento.WspaParametro
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneErroreException
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneNessunElementoException
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class NextStepParametroService implements IWspaParametroService {
    private final NextStepParametroRepository nextStepParametroRepository
    private final GsdService gsdService

    NextStepParametroService(NextStepParametroRepository nextStepParametroRepository,
                             GsdService gsdService) {
        this.nextStepParametroRepository = nextStepParametroRepository
        this.gsdService = gsdService
    }

    @Override
    NextStepParametro create() {
        return new NextStepParametro(flagVisibile: Boolean.TRUE)
    }

    @Override
    void sincronizza() {
        Integer ret
        try {
            ret = gsdService.popolaParametriWspa(EServizioPagamento.NEXTSTEP)
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
    NextStepParametro get(String id) {
        return nextStepParametroRepository.findById(id)
    }

    @Override
    Page<NextStepParametro> listAllByDescrizioneLike(String parametroLike, PageRequest p) {
        return nextStepParametroRepository.findAllByIdLikeIgnoreCaseOrDescrizioneLikeIgnoreCase(TestoUtils.isVuoto(parametroLike) ? '%' :parametroLike, p)
    }

    @Override
    NextStepParametro save(WspaParametro obj) {
        return nextStepParametroRepository.save(obj as NextStepParametro)
    }

    @Override
    void delete(WspaParametro obj) {
        nextStepParametroRepository.delete(obj as NextStepParametro)
    }
}
