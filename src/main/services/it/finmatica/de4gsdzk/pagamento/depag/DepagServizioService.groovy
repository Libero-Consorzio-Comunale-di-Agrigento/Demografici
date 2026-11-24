package it.finmatica.de4gsdzk.pagamento.depag

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneErroreException
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneNessunElementoException
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class DepagServizioService {
    private final DepagServizioRepository depagServizioRepository
    private final GsdService gsdService

    DepagServizioService(DepagServizioRepository depagServizioRepository,
                         GsdService gsdService) {
        this.depagServizioRepository = depagServizioRepository
        this.gsdService = gsdService
    }

    DepagServizio get(String id) {
        return depagServizioRepository.findById(id)
    }

    void sincronizza() {
        Integer ret
        try {
            ret = gsdService.popolaServiziWspa()
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

    List<DepagServizio> listAll() {
        Sort sort = new Sort(SortUtils.idAsc)
        return depagServizioRepository.findAll(sort)
    }

    Page<DepagServizio> listAllByDescrizione(String filtro, PageRequest p) {
        return depagServizioRepository.findAllByDescrizioneLikeIgnoreCase(TestoUtils.isVuoto(filtro) ? '%' : filtro, p)
    }

    DepagServizio save(DepagServizio obj) {
        return depagServizioRepository.save(obj)
    }

    void delete(DepagServizio obj) {
        depagServizioRepository.delete(obj)
    }
}
