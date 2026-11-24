package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivLuogoNascitaService {

	private final GsdService gsdService

	private final CivLuogoNascitaRepository civLuogoNascitaRepository

    CivLuogoNascitaService(CivLuogoNascitaRepository civLuogoNascitaRepository, GsdService gsdService) {

		this.civLuogoNascitaRepository = civLuogoNascitaRepository
		this.gsdService = gsdService
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
			obj.id = gsdService.getIntegerIdFromSequence(obj)
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
