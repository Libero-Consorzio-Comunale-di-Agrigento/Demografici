package it.finmatica.de4gsdzk.elettorale

import groovy.util.logging.Slf4j
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class EleElezioneService {

    EleElezioneRepository eleElezioneRepository

    EleElezioneService(EleElezioneRepository eleElezioneRepository) {
        this.eleElezioneRepository = eleElezioneRepository
    }

    Page<EleElezione> findAll(PageRequest p) {
        return eleElezioneRepository.findAllByDataNotNull(p)
    }
}
