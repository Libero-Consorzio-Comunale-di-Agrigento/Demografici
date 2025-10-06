package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerSindacoRepository
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerSindacoService {

	private final CerSindacoRepository cerSindacoRepository

    CerSindacoService(CerSindacoRepository cerSindacoRepository) {
		this.cerSindacoRepository = cerSindacoRepository
	}

	List<CerSindaco> listAllByIdLike(String filtro){
		if (TestoUtils.isVuoto(filtro)) {
			return cerSindacoRepository.findAll()
		} else {
			return cerSindacoRepository.findAllByIdLikeIgnoreCase(SqlUtils.beginsAndEndsLike(filtro))
		}
	}

	CerSindaco save(CerSindaco obj) {
		//validaDati(tipoOperazione, obj)
		return cerSindacoRepository.save(obj)
	}

}
