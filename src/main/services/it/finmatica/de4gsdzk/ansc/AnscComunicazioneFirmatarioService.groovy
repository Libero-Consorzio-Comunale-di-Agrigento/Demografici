package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscComunicazioneFirmatarioRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscComunicazioneFirmatarioService {

    private final AnscComunicazioneFirmatarioRepository anscComunicazioneFirmatarioRepository

    AnscComunicazioneFirmatarioService(AnscComunicazioneFirmatarioRepository anscComunicazioneFirmatarioRepository) {
        this.anscComunicazioneFirmatarioRepository = anscComunicazioneFirmatarioRepository
    }

}
