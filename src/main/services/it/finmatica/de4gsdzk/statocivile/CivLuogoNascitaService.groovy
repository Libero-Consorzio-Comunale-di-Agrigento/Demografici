package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivLuogoNascitaRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivLuogoNascitaService {

	private final StatoCivileService statoCivileService

	private final CivLuogoNascitaRepository civLuogoNascitaRepository

    CivLuogoNascitaService(CivLuogoNascitaRepository civLuogoNascitaRepository, StatoCivileService statoCivileService) {

		this.civLuogoNascitaRepository = civLuogoNascitaRepository
		this.statoCivileService = statoCivileService
	}

	CivLuogoNascita get (Integer id){
		return civLuogoNascitaRepository.findById(id)
	}

	Page<CivLuogoNascita> listAllByDescrizioneLike(String filtro, PageRequest p){
		if ( (filtro?.trim()?:"") != "") {
			return civLuogoNascitaRepository.findAllByDescrizioneLikeIgnoreCase(filtro, p)
		} else {
			return civLuogoNascitaRepository.findAll(p)
		}
	}

	private void validaDati(CivLuogoNascita obj){
		if ( (obj.descrizione?:"") == "") {
			throw new CampoMandatoryRuntimeException("- Valorizzare il campo descrizione")
		}
	}

	CivLuogoNascita save (CivLuogoNascita obj){
		validaDati(obj)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = statoCivileService.getIntegerIdFromSequence(obj)
		}

		log.info("Lancio salvataggio su CIVDG2 per id " + obj.id)
		return  civLuogoNascitaRepository.save(obj)
	}

	void delete(CivLuogoNascita obj){
		if (obj.id != null) {
			civLuogoNascitaRepository.delete(obj)
		}
	}

}
