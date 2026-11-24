package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivRichiamoComposizioneService {

	private final GsdService gsdService

	private final CivRichiamoComposizioneRepository civRichiamoComposizioneRepository

    CivRichiamoComposizioneService(CivRichiamoComposizioneRepository civRichiamoComposizioneRepository, GsdService gsdService){

		this.civRichiamoComposizioneRepository = civRichiamoComposizioneRepository
		this.gsdService = gsdService
	}

	CivRichiamoComposizione get (Long id){
		return civRichiamoComposizioneRepository.findById(id)
	}

	Page<CivRichiamoComposizione> listByTipoAtto(Integer tipoAtto, String filtro, PageRequest p){
		if (tipoAtto != null){
			if (TestoUtils.isVuoto(filtro?.trim())) {
				return civRichiamoComposizioneRepository.findAllByTipoAtto(tipoAtto, p)
			} else {
				try{
					Integer r = new Integer(Integer.parseInt(filtro))
					return civRichiamoComposizioneRepository.findAllByTipoAttoAndRichiamo(tipoAtto, r, p)
				} catch (NumberFormatException e){
					return civRichiamoComposizioneRepository.findAllByTipoAttoAndDescrizioneLikeIgnoreCase(tipoAtto, SqlUtils.beginsAndEndsLike(filtro), p)
				}
			}
		}
		return null
	}

	private void validaDati(CivRichiamoComposizione obj) {
		if ( (obj.tipoAtto == null) || (obj.richiamo == null) || (obj.progressivo == null) ) {
			throw new CampoMandatoryRuntimeException()
		}
	}

	CivRichiamoComposizione save (CivRichiamoComposizione obj){
		validaDati(obj)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}

		return  civRichiamoComposizioneRepository.save(obj)
	}


}
