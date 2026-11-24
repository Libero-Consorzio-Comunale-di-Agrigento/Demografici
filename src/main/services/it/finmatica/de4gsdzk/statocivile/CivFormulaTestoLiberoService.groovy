package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.TipoAttoUtils
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivFormulaTestoLiberoService {

	private final GsdService gsdService

	private final CivFormulaTestoLiberoRepository civFormulaTestoLiberoRepository

	CivFormulaTestoLiberoService(CivFormulaTestoLiberoRepository civFormulaTestoLiberoRepository, GsdService gsdService){

		this.civFormulaTestoLiberoRepository = civFormulaTestoLiberoRepository
		this.gsdService = gsdService
	}

	CivFormulaTestoLibero get (Long id){
		return civFormulaTestoLiberoRepository.findById(id)
	}

	List<CivFormulaTestoLibero> listAllByUkAttoAndTipoAtto(String identificativoAtto, Integer tipoAtto) {
		return civFormulaTestoLiberoRepository.findAllByUkAttoAndTipoAtto(identificativoAtto, tipoAtto)
	}

	List<CivFormulaTestoLibero> listAllByUkAttoAndRichiamoNotIn(String identificativoAtto, List<Integer> listaRichiami) {
		return civFormulaTestoLiberoRepository.findAllByUkAttoAndRichiamoNotIn(identificativoAtto, listaRichiami)
	}

	List<CivFormulaTestoLibero> listAllByUKAttoAndRichiamo (String identificativoAtto, Integer richiamo){
		return civFormulaTestoLiberoRepository.findAllByUkAttoAndRichiamo(identificativoAtto, richiamo)
	}

	private void validaDati(CivFormulaTestoLibero obj, ETipoAtto tipoAttoEnumSource){
		Boolean emptyMandatoryFields = TipoAttoUtils.isEstremiAttoEmpty(obj, tipoAttoEnumSource)
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto"))
		}

		ValidationUtils.validaDatiObbligatori(obj, [idAtto: false, version:false])
	}

	CivFormulaTestoLibero save (CivFormulaTestoLibero obj, ETipoAtto tipoAttoEnumSource){
		validaDati(obj, tipoAttoEnumSource)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su CIVTLI_FORMULE per id " + obj.id)
		return  civFormulaTestoLiberoRepository.save(obj)
	}

	void delete(CivFormulaTestoLibero obj){
		log.info("Tento cancellazione su CIVTLI_FORMULE per id " + obj.id)
		civFormulaTestoLiberoRepository.delete(obj)
	}

}
