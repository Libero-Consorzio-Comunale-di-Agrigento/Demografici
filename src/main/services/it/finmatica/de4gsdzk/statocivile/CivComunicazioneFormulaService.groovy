package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneFormulaRepository
import it.finmatica.de4gsdzk.utils.ETipoIndividuiAtto
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivComunicazioneFormulaService {

	private final StatoCivileService statoCivileService

	private final CivComunicazioneAttoService civComunicazioneAttoService

	private final CivComunicazioneFormulaRepository civComunicazioneFormulaRepository

    CivComunicazioneFormulaService(CivComunicazioneFormulaRepository civComunicazioneFormulaRepository,
								   StatoCivileService statoCivileService, CivComunicazioneAttoService civComunicazioneAttoService){

		this.civComunicazioneFormulaRepository = civComunicazioneFormulaRepository
		this.statoCivileService = statoCivileService
		this.civComunicazioneAttoService = civComunicazioneAttoService
	}

	CivComunicazioneFormula get (Long id){
		CivComunicazioneFormula f = civComunicazioneFormulaRepository.findById(id)
		return f
	}

	CivComunicazioneFormula getByUk (String formula, Integer idCom){
		return civComunicazioneFormulaRepository.findByUk(formula, idCom)
	}

	List<CivComunicazioneFormula> listAllDefaultComunicazioni(String idFormulaDfa, CivAttoBaseDomain obj, CivAnagrafe anagrafe){
		List<ETipoIndividuiAtto> listaTipoIndividui = civComunicazioneAttoService.getTipiIndividuiAtto(obj, anagrafe)
		return civComunicazioneFormulaRepository.findAllByFormulaDfaAndTipoIndividui(idFormulaDfa, listaTipoIndividui)
	}

	Page<CivComunicazioneFormula> listAllByComunicazioneAndFormulaLike(CivComunicazione comunicazione, String filtro, Pageable pageable) {
		if (comunicazione) {
			return civComunicazioneFormulaRepository.findAllByComunicazioneAndFormulaLike(comunicazione, filtro, pageable)
		}
		return null
	}

	Page<CivComunicazioneFormula> listAllByComunicazione(CivComunicazione comunicazione, Pageable pageable) {
		if (comunicazione) {
			return civComunicazioneFormulaRepository.findAllByComunicazioneAndFormulaLike(comunicazione, "%", pageable)
		}
		return null
	}

	private void validaDati(CivComunicazioneFormula obj) {
		ValidationUtils.validaDatiObbligatori(obj)
	}

	CivComunicazioneFormula save (CivComunicazioneFormula obj){
		validaDati(obj)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = statoCivileService.getIdFromSequence(obj)
		}

		return  civComunicazioneFormulaRepository.save(obj)
	}

	void delete(CivComunicazioneFormula obj) {
		civComunicazioneFormulaRepository.delete(obj)
	}

}
