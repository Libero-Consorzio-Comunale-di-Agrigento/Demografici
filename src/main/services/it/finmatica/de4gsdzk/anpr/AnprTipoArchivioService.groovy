package it.finmatica.de4gsdzk.anpr

import groovy.util.logging.Slf4j
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnprTipoArchivioService {

    private final AnprTipoArchivioRepository anprTipoArchivioRepository

    AnprTipoArchivioService(AnprTipoArchivioRepository anprTipoArchivioRepository) {
        this.anprTipoArchivioRepository = anprTipoArchivioRepository
    }

    List<AnprTipoArchivio> listAll() {
        return anprTipoArchivioRepository.findAll(new Sort(new Sort.Order(Sort.Direction.ASC, "descrizione")))
    }
}
