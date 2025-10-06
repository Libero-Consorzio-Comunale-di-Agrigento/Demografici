package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivTestoFormulaRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivTestoFormulaService {
	private final CivTestoFormulaRepository civTestoFormulaRepository

    CivTestoFormulaService(CivTestoFormulaRepository civTestoFormulaRepository) {
		this.civTestoFormulaRepository = civTestoFormulaRepository
	}

	CivTestoFormula get (String id){
		return civTestoFormulaRepository.findById(id)
	}

	private void validaDati(CivTestoFormula obj) {
		if ((obj.id?:"") == "") {
			throw new CampoMandatoryRuntimeException("( Formula )")
		}
	}

	CivTestoFormula save (CivTestoFormula obj){
		validaDati(obj)

		return  civTestoFormulaRepository.save(obj)
	}

}
