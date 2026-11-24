package it.finmatica.de4gsdzk.elettorale

import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class EleVariabileTimbroService {

    private final EleVariabileTimbroRepository eleVariabileTimbroRepository

    EleVariabileTimbroService(EleVariabileTimbroRepository eleVariabileTimbroRepository) {
        this.eleVariabileTimbroRepository = eleVariabileTimbroRepository
    }

    List<String> listVariabili() {
        return eleVariabileTimbroRepository.findAllByOrderBySequenzaAsc()*.variabile
    }

}
