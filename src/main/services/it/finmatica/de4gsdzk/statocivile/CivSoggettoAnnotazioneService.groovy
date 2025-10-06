package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivSoggettoAnnotazioneRepository
import org.springframework.data.domain.Page
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivSoggettoAnnotazioneService {

	private final CivSoggettoAnnotazioneRepository civSoggettoAnnotazioneRepository

	CivSoggettoAnnotazioneService(CivSoggettoAnnotazioneRepository civSoggettoAnnotazioneRepository) {
		this.civSoggettoAnnotazioneRepository = civSoggettoAnnotazioneRepository
	}

	Page<CivSoggettoAnnotazione> list (Map params) {
		if (params.tipoComune == null){
			return null
		}
		if ( (params.tipoComune == 1) && (params.tipoAtto == null) ){
			return null
		}
		if ( (params.tipoComune == 0) && (params.tipoAttoRif == null) ){
			return null
		}
		return civSoggettoAnnotazioneRepository.listByParams(params)
	}

	List<CivSoggettoAnnotazione> listAllByIdAttoAndTipoFormula(String identificativoAtto, String tipoFormula){
		return civSoggettoAnnotazioneRepository.findAllByIdAttoAndTipoFormula(identificativoAtto, tipoFormula)
	}

}
