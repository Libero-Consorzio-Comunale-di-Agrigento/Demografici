package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerTipoRichiedenteRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerTipoRichiedenteService {

    private final CerTipoRichiedenteRepository cerTipoRichiedenteRepository

    CerTipoRichiedenteService(CerTipoRichiedenteRepository cerTipoRichiedenteRepository) {
        this.cerTipoRichiedenteRepository = cerTipoRichiedenteRepository
    }

    CerTipoRichiedente get(Integer id) {
        return cerTipoRichiedenteRepository.findById(id)
    }

    List<CerTipoRichiedente> listAll() {
        return cerTipoRichiedenteRepository.findAllByFlagVisibileTrueOrderBySequenza()
    }

}
