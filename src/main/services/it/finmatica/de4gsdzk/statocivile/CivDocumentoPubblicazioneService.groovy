package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivDocumentoPubblicazioneService {

	private final GsdService gsdService

	private final CivDocumentoPubblicazioneRepository civDocumentoPubblicazioneRepository

    CivDocumentoPubblicazioneService(CivDocumentoPubblicazioneRepository civDocumentoPubblicazioneRepository,
                                     GsdService gsdService) {

		this.civDocumentoPubblicazioneRepository = civDocumentoPubblicazioneRepository
		this.gsdService = gsdService
	}

	CivDocumentoPubblicazione getByUkAttoAndTipoAtto(String identificativoAtto, Integer tipoAtto) {
		return civDocumentoPubblicazioneRepository.findByUkAttoAndTipoAtto(identificativoAtto, tipoAtto)
	}

	CivDocumentoPubblicazione getOrCreateByUkAttoAndTipoAtto(String identificativoAtto, Integer tipoAtto) {
		CivDocumentoPubblicazione m = getByUkAttoAndTipoAtto(identificativoAtto, tipoAtto)
		if (!(m)){
			m = new CivDocumentoPubblicazione()
		}
		return m
	}

	private void validaDati(CivDocumentoPubblicazione obj, ETipoAtto tipoAttoEnumSource, Boolean documentoPresentatoPubblicazioneMandatory) {
		Boolean emptyMandatoryFields = Boolean.TRUE
		switch (tipoAttoEnumSource) {
			case ETipoAtto.PUB:
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null) || (obj.documentoPresentatoPubblicazione == null))
				break
			case ETipoAtto.PVU:
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.documentoPresentatoPubblicazione == null))
				break
			case ETipoAtto.UCI:
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || ( (obj.documentoPresentatoPubblicazione == null) && documentoPresentatoPubblicazioneMandatory) )
				break
		}
		String sezioneDocPresentati = "'Documenti Presentati'"
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDocPresentati)
		}
	}

	CivDocumentoPubblicazione save (CivDocumentoPubblicazione obj, ETipoAtto tipoAttoEnumSource, Boolean documentoPresentatoPubblicazioneMandatory = Boolean.TRUE){

		validaDati(obj, tipoAttoEnumSource, documentoPresentatoPubblicazioneMandatory)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su CIVPDO per id " + obj.id)
		return  civDocumentoPubblicazioneRepository.save(obj)
	}

}
