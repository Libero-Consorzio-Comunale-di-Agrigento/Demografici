package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscEndCodificaErroreRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscCodificaErroreService {

    private final AnscEndCodificaErroreRepository anscEndCodificaErroreRepository

    AnscCodificaErroreService(AnscEndCodificaErroreRepository anscEndCodificaErroreRepository) {
        this.anscEndCodificaErroreRepository = anscEndCodificaErroreRepository
    }

    AnscCodificaErrore get (String id){
        return anscEndCodificaErroreRepository.findById(id)
    }

    AnscCodificaErrore getByIdAndFlagGestitoIsNull(String id){
        return anscEndCodificaErroreRepository.findByIdAndFlagGestitoIsNull(id)
    }
}
