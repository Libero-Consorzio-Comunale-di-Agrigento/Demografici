package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscAllegatoRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscAllegatoService {

    private final AnscAllegatoRepository allegatoRepository

    AnscAllegatoService(AnscAllegatoRepository allegatoRepository) {
        this.allegatoRepository = allegatoRepository
    }

    AnscAllegato get (Long id){
        return allegatoRepository.findById(id)
    }
}
