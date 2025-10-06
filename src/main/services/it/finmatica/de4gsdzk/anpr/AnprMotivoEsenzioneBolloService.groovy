package it.finmatica.de4gsdzk.anpr

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anpr.AnprMotivoEsenzioneBolloRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnprMotivoEsenzioneBolloService {

    private final AnprMotivoEsenzioneBolloRepository anprMotivoEsenzioneBolloRepository

    AnprMotivoEsenzioneBolloService(AnprMotivoEsenzioneBolloRepository anprMotivoEsenzioneBolloRepository) {
        this.anprMotivoEsenzioneBolloRepository = anprMotivoEsenzioneBolloRepository
    }

    Page<AnprMotivoEsenzioneBollo> listAllByDescrizione(String filtro, PageRequest p) {
        return anprMotivoEsenzioneBolloRepository.findAllByDescrizioneLikeIgnoreCase(filtro, p)
    }
}
