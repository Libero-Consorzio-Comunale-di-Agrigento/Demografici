package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.IstMd4Repository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class IstMd4Service {

	private final StatoCivileService statoCivileService

	private final CivValidazioneModelloIstatService civValidazioneModelloIstatService

	private final IstMd4Repository istMd4Repository

    IstMd4Service(IstMd4Repository istMd4Repository, StatoCivileService statoCivileService,
				  CivValidazioneModelloIstatService civValidazioneModelloIstatService) {

		this.istMd4Repository = istMd4Repository
		this.statoCivileService = statoCivileService
		this.civValidazioneModelloIstatService = civValidazioneModelloIstatService
	}

	IstMd4 get(Long id){
		return istMd4Repository.findById(id)
	}

	IstMd4 getByUkAtto(String identificativoAtto) {
		return istMd4Repository.findByUkAtto(identificativoAtto)
	}

	private void validaDati(IstMd4 obj){
		civValidazioneModelloIstatService.checkEstremiAtto(obj)

		civValidazioneModelloIstatService.checkChiusuraProvvisorio(obj)
	}

	IstMd4 save (IstMd4 obj){
		validaDati(obj)

		if (obj.id == null){
			obj.id = statoCivileService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su ISTMD4 per id " + obj.id)
		return  istMd4Repository.save(obj)
	}

}
