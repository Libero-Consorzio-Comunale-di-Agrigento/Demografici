package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivPubblicazioneSelectRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivPubblicazioneSelectService {

	private final CivPubblicazioneSelectRepository civPubblicazioneSelectRepository

    CivPubblicazioneSelectService(CivPubblicazioneSelectRepository civPubblicazioneSelectRepository) {
		this.civPubblicazioneSelectRepository = civPubblicazioneSelectRepository
	}

    Page<CivPubblicazioneSelect> listAllByCognome1LikeIgnoreCaseOrNome1LikeIgnoreCaseOrCognome2LikeIgnoreCaseOrNome2LikeIgnoreCase(String filtro, PageRequest p){
        return civPubblicazioneSelectRepository.findAllByCognome1LikeIgnoreCaseOrNome1LikeIgnoreCaseOrCognome2LikeIgnoreCaseOrNome2LikeIgnoreCase(filtro, filtro, filtro, filtro, p)
    }

}
