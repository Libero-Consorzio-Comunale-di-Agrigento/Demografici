package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.IstMd3UProcessoVerbaleRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class IstMd3UProcessoVerbaleService {

	private final StatoCivileService statoCivileService

	private final CivValidazioneModelloIstatService civValidazioneModelloIstatService

	private final IstMd3UProcessoVerbaleRepository istMd3UProcessoVerbaleRepository

	IstMd3UProcessoVerbaleService(IstMd3UProcessoVerbaleRepository istMd3UProcessoVerbaleRepository, StatoCivileService statoCivileService,
								  CivValidazioneModelloIstatService civValidazioneModelloIstatService) {

		this.istMd3UProcessoVerbaleRepository = istMd3UProcessoVerbaleRepository
		this.statoCivileService = statoCivileService
		this.civValidazioneModelloIstatService = civValidazioneModelloIstatService
	}

	IstMd3UProcessoVerbale get(Long id){
		return istMd3UProcessoVerbaleRepository.findById(id)
	}

	IstMd3UProcessoVerbale getByUkAtto(String identificativoAtto) {
		return istMd3UProcessoVerbaleRepository.findByIdAtto(identificativoAtto)
	}

	private void validaDati(IstMd3UProcessoVerbale obj){
		civValidazioneModelloIstatService.checkEstremiAtto(obj)

		civValidazioneModelloIstatService.checkChiusuraProvvisorio(obj)
	}

	IstMd3UProcessoVerbale save (IstMd3UProcessoVerbale obj){
		validaDati(obj)

		if (obj.id == null){
			obj.id = statoCivileService.getIdFromSequence(obj, "ISTMDU")
		}
		log.info("Lancio salvataggio su ISTMDU per id " + obj.id)
		return  istMd3UProcessoVerbaleRepository.save(obj)
	}

}
