package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivTipoRegistroRepository
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivTipoRegistroService {

	private final CivTipoRegistroRepository civTipoRegistroRepository

    CivTipoRegistroService(CivTipoRegistroRepository civTipoRegistroRepository) {
		this.civTipoRegistroRepository = civTipoRegistroRepository
	}

	CivTipoRegistro get (String id){
		return civTipoRegistroRepository.findById(id)
	}

	List<CivTipoRegistro> listAll() {
		return civTipoRegistroRepository.findAll()
	}

	List<CivTipoRegistro> listAllByDescrizioneLike(String filtro){
		return civTipoRegistroRepository.findAllByDescrizioneLikeIgnoreCaseOrderById((filtro?:""))
	}

	private void validaDati(CivTipoRegistro obj){
		ValidationUtils.validaDatiObbligatori(obj)
	}

	CivTipoRegistro save (CivTipoRegistro obj){
		validaDati(obj)

		return civTipoRegistroRepository.save(obj)
	}

}
