package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscComunicazioneAllegatoRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscComunicazioneAllegatoService {

    private final AnscComunicazioneAllegatoRepository anscComunicazioneAllegatoRepository

    AnscComunicazioneAllegatoService(AnscComunicazioneAllegatoRepository anscComunicazioneAllegatoRepository) {
        this.anscComunicazioneAllegatoRepository = anscComunicazioneAllegatoRepository
    }

    Integer existsComunicazioneByIdAllegatoAndInviatoANSC(Long idAllegato){
        return anscComunicazioneAllegatoRepository.existsComunicazioneByIdAllegatoAndInviatoANSC(idAllegato)
    }

}
