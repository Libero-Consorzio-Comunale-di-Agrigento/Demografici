package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoFormulaAnnotazioneDaAtto
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivAnnotazioneTestoLiberoService {

	private final GsdService gsdService

	private final CivAnnotazioneTestoLiberoRepository civAnnotazioneTestoLiberoRepository

    CivAnnotazioneTestoLiberoService(CivAnnotazioneTestoLiberoRepository civAnnotazioneTestoLiberoRepository,
                                     GsdService gsdService) {

		this.civAnnotazioneTestoLiberoRepository = civAnnotazioneTestoLiberoRepository
		this.gsdService = gsdService
	}

	List<CivAnnotazioneTestoLibero> listAllByUkAttoAndTipoAttoAndTipoFormulaIn(String identificativoAtto, ETipoAtto tipoAttoEnum, List<ETipoFormulaAnnotazioneDaAtto> ltf) {
		return civAnnotazioneTestoLiberoRepository.findAllByUkAttoAndTipoAttoAndTipoFormulaIn(identificativoAtto, new Integer(tipoAttoEnum.valore), ltf)
	}

	private void validaDati(CivAnnotazioneTestoLibero obj, ETipoAtto tipoAttoEnumSource){
		if ( (obj.tipoFormula == null) ){
			throw new CampoMandatoryRuntimeException()
		}

		Boolean emptyMandatoryFields = Boolean.TRUE
		switch (tipoAttoEnumSource) {
			case ETipoAtto.MAT:
			case ETipoAtto.MOR:
			case ETipoAtto.UCI:
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null) )
				break
			case ETipoAtto.CIT:
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) )
				break
		}
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto"))
		}
	}

	CivAnnotazioneTestoLibero save (CivAnnotazioneTestoLibero obj, ETipoAtto tipoAttoEnumSource){

		validaDati(obj, tipoAttoEnumSource)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}

		log.info("Lancio salvataggio su CIVTLI_ANNOTAZIONI per id " + obj.id)
		CivAnnotazioneTestoLibero saved = civAnnotazioneTestoLiberoRepository.save(obj)
		return saved
	}

	void delete(CivAnnotazioneTestoLibero obj){
		log.info("Tento cancellazione su CIVTLI_ANNOTAZIONI per id " + obj.id)
		if (obj.id != null){
			civAnnotazioneTestoLiberoRepository.delete(obj)
		}
	}

}
