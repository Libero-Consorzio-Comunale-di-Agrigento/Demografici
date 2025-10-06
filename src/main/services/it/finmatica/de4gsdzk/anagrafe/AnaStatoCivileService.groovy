package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.anagrafe.AnaStatoCivileRepository
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaStatoCivileService {

	private final AnaStatoCivileRepository anaStatoCivileRepository

    AnaStatoCivileService(AnaStatoCivileRepository anaStatoCivileRepository) {
		this.anaStatoCivileRepository = anaStatoCivileRepository
	}

	List<AnaStatoCivile> listAll () {
		return anaStatoCivileRepository.findAll()
	}

	List<AnaStatoCivile> listAllBySesso (ESesso sesso) {
		return anaStatoCivileRepository.findAllBySessoOrderByDescrizione(sesso)
	}

}
