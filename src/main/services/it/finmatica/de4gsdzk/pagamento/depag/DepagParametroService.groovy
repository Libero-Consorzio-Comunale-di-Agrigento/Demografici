package it.finmatica.de4gsdzk.pagamento.depag

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.pagamento.EServizioPagamento
import it.finmatica.de4gsdzk.pagamento.IWspaParametroService
import it.finmatica.de4gsdzk.pagamento.WspaParametro
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneErroreException
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneNessunElementoException
import it.finmatica.de4gsdzk.pagamento.depag.DepagParametroRepository
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class DepagParametroService implements IWspaParametroService {
    private final DepagParametroRepository depagParametroRepository
    private final StatoCivileService statoCivileService

    DepagParametroService(DepagParametroRepository depagParametroRepository, StatoCivileService statoCivileService) {
        this.depagParametroRepository = depagParametroRepository
        this.statoCivileService = statoCivileService
    }

    @Override
    DepagParametro create() {
        return new DepagParametro(flagVisibile: Boolean.TRUE)
    }

    @Override
    void sincronizza() {
        Integer ret
        try {
            ret = statoCivileService.popolaParametriWspa(EServizioPagamento.DEPAG)
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
    DepagParametro get(String id) {
        return depagParametroRepository.findById(id)
    }

    @Override
    Page<DepagParametro> listAllByDescrizioneLike(String parametroLike, PageRequest p) {
        return depagParametroRepository.findAllByIdLikeIgnoreCaseOrDescrizioneLikeIgnoreCase(TestoUtils.isVuoto(parametroLike) ? '%' :parametroLike, p)
    }

    @Override
    DepagParametro save(WspaParametro obj) {
        return depagParametroRepository.save(obj as DepagParametro)
    }

    @Override
    void delete(WspaParametro obj) {
        depagParametroRepository.delete(obj as DepagParametro)
    }
}
