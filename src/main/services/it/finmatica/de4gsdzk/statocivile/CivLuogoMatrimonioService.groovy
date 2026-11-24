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
class CivLuogoMatrimonioService {

	private final GsdService gsdService

	private final CivLuogoMatrimonioRepository civLuogoMatrimonioRepository

    CivLuogoMatrimonioService(CivLuogoMatrimonioRepository civLuogoMatrimonioRepository, GsdService gsdService) {

		this.civLuogoMatrimonioRepository = civLuogoMatrimonioRepository
		this.gsdService = gsdService
	}

	CivLuogoMatrimonio get (Integer id){
		return civLuogoMatrimonioRepository.findById(id)
	}

	List<CivLuogoMatrimonio> listAllMinistriLike(String filtro){
		return civLuogoMatrimonioRepository.findAllByMinistroLikeIgnoreCaseAndMinistroNotNull((filtro?:""))
	}

	List<String> listAllDistinctQualificaLike(String filtro){
		return civLuogoMatrimonioRepository.findAllDistinctQualificaLike((filtro?:""))
	}

	Page<CivLuogoMatrimonio> listAllByDescrizioneLike(String filtro, PageRequest p){
		if ( (filtro?.trim()?:"") != "") {
			return civLuogoMatrimonioRepository.findAllByDescrizioneLikeIgnoreCase(filtro, p)
		} else {
			return civLuogoMatrimonioRepository.findAll(p)
		}
	}

	private void validaDati(CivLuogoMatrimonio obj){
		if ( (obj.descrizione?:"") == "") {
			throw new CampoMandatoryRuntimeException("- Valorizzare il campo descrizione")
		}
	}

	CivLuogoMatrimonio save (CivLuogoMatrimonio obj){
		validaDati(obj)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = gsdService.getIntegerIdFromSequence(obj)
		}
		return  civLuogoMatrimonioRepository.save(obj)
	}

	void delete(CivLuogoMatrimonio obj){
		if (obj.id != null) {
			civLuogoMatrimonioRepository.delete(obj)
		}
	}
}
