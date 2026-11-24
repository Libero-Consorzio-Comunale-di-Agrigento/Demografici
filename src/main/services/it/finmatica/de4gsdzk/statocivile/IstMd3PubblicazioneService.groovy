package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class IstMd3PubblicazioneService {

	private final GsdService gsdService

	private final CivValidazioneModelloIstatService civValidazioneModelloIstatService

	private final IstMd3PubblicazioneRepository istMd3PubblicazioneRepository

    IstMd3PubblicazioneService(IstMd3PubblicazioneRepository istMd3PubblicazioneRepository, GsdService gsdService,
                               CivValidazioneModelloIstatService civValidazioneModelloIstatService) {

		this.istMd3PubblicazioneRepository = istMd3PubblicazioneRepository
		this.gsdService = gsdService
		this.civValidazioneModelloIstatService = civValidazioneModelloIstatService
	}

	IstMd3Pubblicazione get(Long id){
		return istMd3PubblicazioneRepository.findById(id)
	}

	IstMd3Pubblicazione getByUkAtto(String identificativoAtto) {
		return istMd3PubblicazioneRepository.findByIdAtto(identificativoAtto)
	}

	private void validaDati(IstMd3Pubblicazione obj){
		civValidazioneModelloIstatService.checkEstremiAtto(obj)

		civValidazioneModelloIstatService.checkChiusuraProvvisorio(obj)
	}

	IstMd3Pubblicazione save (IstMd3Pubblicazione obj){
		validaDati(obj)

		if (obj.id == null){
			obj.id = gsdService.getIdFromSequence(obj, "ISTMD3")
		}
		log.info("Lancio salvataggio su ISTMD3 per id " + obj.id)
		return  istMd3PubblicazioneRepository.save(obj)
	}

}
