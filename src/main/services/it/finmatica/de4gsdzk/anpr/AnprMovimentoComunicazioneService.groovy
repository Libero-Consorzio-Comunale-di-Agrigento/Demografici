package it.finmatica.de4gsdzk.anpr

import groovy.util.logging.Slf4j
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnprMovimentoComunicazioneService {

    private final AnprMovimentoComunicazioneRepository anprMovimentoComunicazioneRepository

    AnprMovimentoComunicazioneService(AnprMovimentoComunicazioneRepository anprMovimentoComunicazioneRepository) {
        this.anprMovimentoComunicazioneRepository = anprMovimentoComunicazioneRepository
    }

    List<AnprMovimentoComunicazione> findAllByIdOrderByDataInvio(Long id) {
        return anprMovimentoComunicazioneRepository.findAllByIdOrderByDataInvio(id)
    }
}
