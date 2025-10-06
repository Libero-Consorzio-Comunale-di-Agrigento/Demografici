package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaEnteRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaEnteService {

	private final AnaEnteRepository anaEnteRepository

    AnaEnteService(AnaEnteRepository anaEnteRepository) {
		this.anaEnteRepository = anaEnteRepository
	}

	AnaEnte get (Integer id){
		return anaEnteRepository.findById(id)
	}

	Page<AnaEnte> listAllByDescrizione (String filtro, PageRequest p) {
		if ( (filtro?.trim()?:"") != "") {
			return anaEnteRepository.findAllByDescrizioneLikeIgnoreCase(filtro, p)
		} else {
			return anaEnteRepository.findAll(p)
		}
	}

}
