package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivLuogoDecessoRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivLuogoDecessoService {

	private final StatoCivileService statoCivileService

	private final CivLuogoDecessoRepository civLuogoDecessoRepository

	CivLuogoDecessoService(CivLuogoDecessoRepository civLuogoDecessoRepository, StatoCivileService statoCivileService) {

		this.civLuogoDecessoRepository = civLuogoDecessoRepository
		this.statoCivileService = statoCivileService
	}

	CivLuogoDecesso get (Integer id){
		return civLuogoDecessoRepository.findById(id)
	}

	Page<CivLuogoDecesso> listAllByDescrizioneLike(String filtro, PageRequest p){
		if ( (filtro?.trim()?:"") != "") {
			return civLuogoDecessoRepository.findAllByDescrizioneLikeIgnoreCase(filtro, p)
		} else {
			return civLuogoDecessoRepository.findAll(p)
		}
	}

	List<String> listAllDistinctRicevutoDaByRicevutoDaLike(String filtro){
		return civLuogoDecessoRepository.findAllDistinctRicevutoDaByRicevutoDaLike((filtro?:""))
	}

	private void validaDati(CivLuogoDecesso obj){
		if ( (obj.descrizione?:"") == "") {
			throw new CampoMandatoryRuntimeException("- Valorizzare il campo descrizione")
		}
	}

	CivLuogoDecesso save (CivLuogoDecesso obj){
		validaDati(obj)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = statoCivileService.getIntegerIdFromSequence(obj)
		}
		return  civLuogoDecessoRepository.save(obj)
	}

	void delete(CivLuogoDecesso obj){
		if (obj.id != null) {
			civLuogoDecessoRepository.delete(obj)
		}
	}

}
