package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.statocivile.CivUfficialeRepository
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivUfficialeService {

	private final UtenteCustomService utenteCustomService

	private final CivUfficialeRepository civUfficialeRepository

	CivUfficialeService(CivUfficialeRepository civUfficialeRepository, UtenteCustomService utenteCustomService) {

		this.civUfficialeRepository = civUfficialeRepository
		this.utenteCustomService = utenteCustomService
	}

	CivUfficiale get (Integer id){
		return civUfficialeRepository.findById(id)
	}

	List<CivUfficiale> listAllByCognomeNomeLike(String filtro){
		return civUfficialeRepository.findAllByCognomeNomeLikeIgnoreCaseOrderByCognomeNome((filtro?:""))
	}

	List<String> listAllDistinctQualificaByQualificaLike(String filtro){
		return civUfficialeRepository.findAllDistinctQualificaByQualificaLike((filtro?:""))
	}

	Page<CivUfficiale> listAllByCognomeNomeOrQualificaLike(String filtro, PageRequest p){
		if ( (filtro?.trim()?:"") != "") {
			return civUfficialeRepository.findAllByCognomeNomeLikeIgnoreCaseOrQualificaLikeIgnoreCase(SqlUtils.beginsAndEndsLike(filtro), SqlUtils.beginsAndEndsLike(filtro), p)
		} else {
			return civUfficialeRepository.findAll(p)
		}
	}

	CivUfficiale getByCognomeNome (String val){
		return civUfficialeRepository.findByCognomeNome(val)
	}

	CivUfficiale getByCognomeNomeUtenteCorrente(){
		return civUfficialeRepository.findByCognomeNome(utenteCustomService.getLoggedUserUsername())
	}

	private void validaDati(CivUfficiale obj) {
		if ((obj.cognomeNome?.trim()?:"") == ""){
			throw new CampoMandatoryRuntimeException("( Cognome/Nome)")
		}
	}

	CivUfficiale save (CivUfficiale obj){
		validaDati(obj)

		if (obj.id == null){
			// solo in caso di inserimento
			Object[] o = civUfficialeRepository.findMaxId()
			obj.id = (new Integer (o[0]))
		}

		log.info("Lancio salvataggio su CIVDUF per id " + obj.id)
		return civUfficialeRepository.save(obj)
	}

	void delete(CivUfficiale obj){
		if (obj.id != null){
			civUfficialeRepository.delete(obj)
		}
	}

}
