package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.util.logging.Slf4j
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaDichiaranteService {

    private final AnaDichiaranteRepository anaDichiaranteRepository

    AnaDichiaranteService(AnaDichiaranteRepository anaDichiaranteRepository) {
        this.anaDichiaranteRepository = anaDichiaranteRepository
    }

    Page<AnaDichiarante> listAllByRicercaPratica (RicercaPratica r, PageRequest p) {
        return anaDichiaranteRepository.listAllByRicercaPratica(r,p)
    }

}
