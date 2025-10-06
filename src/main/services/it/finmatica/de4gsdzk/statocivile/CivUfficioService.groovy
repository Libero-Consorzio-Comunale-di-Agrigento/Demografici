package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivUfficioRepository
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivUfficioService {

	private final CivUfficioRepository civUfficioRepository

    CivUfficioService(CivUfficioRepository civUfficioRepository) {
		this.civUfficioRepository = civUfficioRepository
	}

	CivUfficio get (Integer id){
		return civUfficioRepository.findById(id)
	}

	Page<CivUfficio> listAllBySedeLike(String filtro, PageRequest p){
		if ( (filtro?.trim()?:"") != "") {
			return civUfficioRepository.findAllBySedeLikeIgnoreCase(SqlUtils.beginsAndEndsLike(filtro), p)
		} else {
			return civUfficioRepository.findAll(p)
		}
	}

	private void validaDati(CivUfficio obj) {
		if (obj.id == null){
			throw new CampoMandatoryRuntimeException("( Ufficio )")
		}
	}

	CivUfficio save (CivUfficio obj){
		validaDati(obj)

		return civUfficioRepository.save(obj)
	}

	void delete(CivUfficio obj){
		civUfficioRepository.delete(obj)
	}

}
