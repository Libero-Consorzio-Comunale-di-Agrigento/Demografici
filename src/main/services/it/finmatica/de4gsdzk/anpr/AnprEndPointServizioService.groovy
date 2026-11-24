package it.finmatica.de4gsdzk.anpr

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnprEndPointServizioService {

    private final AnprEndPointServizioRepository anprEndPointServizioRepository

    AnprEndPointServizioService(AnprEndPointServizioRepository anprEndPointServizioRepository) {
        this.anprEndPointServizioRepository = anprEndPointServizioRepository
    }

    List<AnprEndPointServizio> findAllByFlagModificaPreIsTrue() {
        return anprEndPointServizioRepository.findAllByFlagModificaPreIsTrueOrderByIdAsc()
    }
}
