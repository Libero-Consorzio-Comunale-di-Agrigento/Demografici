package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCampoRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscCampoService {

    private final AnscCampoRepository anscCampoRepository

    AnscCampoService(AnscCampoRepository anscCampoRepository) {
        this.anscCampoRepository = anscCampoRepository
    }

    List<AnscCampo> listAllBySezione (AnscSezione sezione){
        return anscCampoRepository.findAllBySezioneOrderBySequenzaAsc(sezione)
    }
}
