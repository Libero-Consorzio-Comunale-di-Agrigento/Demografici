package it.finmatica.de4gsdzk.anpr

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anpr.AnprTutelaRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnprTutelaService {

    private final AnprTutelaRepository anprTutelaRepository

    AnprTutelaService(AnprTutelaRepository anprTutelaRepository) {
        this.anprTutelaRepository = anprTutelaRepository
    }

    List<AnprTutela> listAll() {
        return anprTutelaRepository.findAll()
    }
}
