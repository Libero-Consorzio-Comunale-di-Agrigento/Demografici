package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscConsolatoRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscConsolatoService {

    private final AnscConsolatoRepository anscConsolatoRepository

    AnscConsolatoService(AnscConsolatoRepository anscConsolatoRepository) {
        this.anscConsolatoRepository = anscConsolatoRepository
    }

    Page<AnscConsolato> listAllByDescrizioneLike(String filtro, Pageable p){
        return anscConsolatoRepository.findAllByDescrizioneLikeIgnoreCase(filtro, p)
    }
}
