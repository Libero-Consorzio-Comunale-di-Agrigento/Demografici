package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivNotaFormulaRepository
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivNotaFormulaService {

	private final StatoCivileService statoCivileService

	private final CivNotaFormulaRepository civNotaFormulaRepository

    CivNotaFormulaService(CivNotaFormulaRepository civNotaFormulaRepository, StatoCivileService statoCivileService) {

		this.civNotaFormulaRepository = civNotaFormulaRepository
		this.statoCivileService = statoCivileService
	}

	CivNotaFormula get (Long id){
		return civNotaFormulaRepository.findById(id)
	}

	List<CivNotaFormula> listAllByFormula(String idFormula, Sort s){
		if (idFormula){
			return civNotaFormulaRepository.findAllByFormula(idFormula, s)
		}
		return []
	}

	List<CivNotaFormula> listAllByFormulaAndVariabileIn(String idFormula, List<Integer> listaVariabili){
		if (idFormula){
			List<CivNotaFormula> l = civNotaFormulaRepository.findAllByFormulaAndVariabileIn(idFormula, listaVariabili)
			return l
		}
		return []
	}

	private void validaDati(CivNotaFormula obj) {
		if (obj.formula == null) {
			throw new CampoMandatoryRuntimeException("( Formula)")
		}
	}

	CivNotaFormula save (CivNotaFormula obj){
		validaDati(obj)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = statoCivileService.getIdFromSequence(obj)
		}
		return  civNotaFormulaRepository.save(obj)
	}

	void delete(CivNotaFormula obj){
		log.info("Tento cancellazione su CIVNFA per id " + obj.id)
		civNotaFormulaRepository.delete(obj)
	}

}
