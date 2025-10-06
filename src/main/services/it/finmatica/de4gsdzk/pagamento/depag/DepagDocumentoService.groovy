package it.finmatica.de4gsdzk.pagamento.depag

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneErroreException
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneNessunElementoException
import it.finmatica.de4gsdzk.pagamento.depag.DepagDocumentoRepository
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class DepagDocumentoService {
    private final DepagDocumentoRepository depagDocumentoRepository
    private final StatoCivileService statoCivileService

    DepagDocumentoService(DepagDocumentoRepository depagDocumentoRepository, StatoCivileService statoCivileService) {
        this.depagDocumentoRepository = depagDocumentoRepository
        this.statoCivileService = statoCivileService
    }

    DepagDocumento get(Long id) {
        return depagDocumentoRepository.findById(id)
    }

    void sincronizza() {
        Integer ret
        try {
            ret = statoCivileService.popolaDocumentiWspa()
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

    Page<DepagDocumento> listAllByDescrizione(String filtro, PageRequest p) {
        return depagDocumentoRepository.findAllByTipoCertificatoDescrizioneLikeIgnoreCase(TestoUtils.isVuoto(filtro) ? '%' : filtro, p)
    }

    DepagDocumento save(DepagDocumento obj) {
        return depagDocumentoRepository.save(obj)
    }

    void delete(DepagDocumento obj) {
        depagDocumentoRepository.delete(obj)
    }
}
