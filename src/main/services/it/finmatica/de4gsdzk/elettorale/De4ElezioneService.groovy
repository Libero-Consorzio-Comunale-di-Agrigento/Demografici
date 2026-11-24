package it.finmatica.de4gsdzk.elettorale

import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class De4ElezioneService {

    private final De4ElezioneRepository de4ElezioneRepository

    De4ElezioneService(De4ElezioneRepository de4ElezioneRepository) {
        this.de4ElezioneRepository = de4ElezioneRepository
    }

    List<De4Elezione> findAllByElezione(EleElezione elezione) {
        return de4ElezioneRepository.findAllByElezione(elezione)
    }

    List<De4Elezione> findAll() {
        return de4ElezioneRepository.findAll()
    }


}
