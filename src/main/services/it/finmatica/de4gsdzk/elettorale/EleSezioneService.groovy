package it.finmatica.de4gsdzk.elettorale

import groovy.util.logging.Slf4j
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class EleSezioneService {

    EleSezioneRepository eleSezioneRepository

    EleSezioneService(EleSezioneRepository eleSezioneRepository) {
        this.eleSezioneRepository = eleSezioneRepository
    }

    Integer getSezioneMin() {
        return  eleSezioneRepository.getSezioneMin()
    }

    Integer getSezioneMax() {
            return  eleSezioneRepository.getSezioneMax()
    }
}
