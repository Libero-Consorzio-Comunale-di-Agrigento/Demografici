package it.finmatica.de4gsdzk.pagamento.depag

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.pagamento.IWspaVoceCostoService
import it.finmatica.de4gsdzk.pagamento.WspaVoceCosto
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
class DepagVoceCostoService implements IWspaVoceCostoService {
    private final DepagVoceCostoRepository depagVoceCostoRepository
    private final GsdService gsdService

    DepagVoceCostoService(DepagVoceCostoRepository depagVoceCostoRepository, GsdService gsdService) {
        this.depagVoceCostoRepository = depagVoceCostoRepository
        this.gsdService = gsdService
    }

    @Override
    DepagVoceCosto create() {
        return new DepagVoceCosto()
    }

    @Override
    void sincronizza() {
        Integer ret
        try {
            ret = gsdService.popolaVociCostoWspa()
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
    DepagVoceCosto get(Long id) {
        return depagVoceCostoRepository.findById(id)
    }

    @Override
    Page<DepagVoceCosto> listAllByDescrizioneLike(String parametroLike, PageRequest p) {
        return depagVoceCostoRepository.findAllByTariffaDirittoDescrizioneLikeIgnoreCase(TestoUtils.isVuoto(parametroLike) ? '%' : parametroLike, p)
    }

    @Override
    DepagVoceCosto save(WspaVoceCosto obj) {
        return depagVoceCostoRepository.save(obj as DepagVoceCosto)
    }

    @Override
    void delete(WspaVoceCosto obj) {
        depagVoceCostoRepository.delete(obj as DepagVoceCosto)
    }
}
