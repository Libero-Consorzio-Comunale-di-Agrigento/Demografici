package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.IstMd4BisRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class IstMd4BisService {

	private final StatoCivileService statoCivileService

    private final CivValidazioneModelloIstatService civValidazioneModelloIstatService

	private final IstMd4BisRepository istMd4BisRepository

    IstMd4BisService(IstMd4BisRepository istMd4BisRepository, StatoCivileService statoCivileService,
                     CivValidazioneModelloIstatService civValidazioneModelloIstatService) {

        this.istMd4BisRepository = istMd4BisRepository
		this.statoCivileService = statoCivileService
        this.civValidazioneModelloIstatService = civValidazioneModelloIstatService
	}

	IstMd4Bis get(Long id){
		return istMd4BisRepository.findById(id)
	}

	IstMd4Bis getByUkAtto(String identificativoAtto) {
		return istMd4BisRepository.findByUkAtto(identificativoAtto)
	}

	private void validaDati(IstMd4Bis obj){
        civValidazioneModelloIstatService.checkEstremiAtto(obj)

        civValidazioneModelloIstatService.checkChiusuraProvvisorio(obj)
	}

	IstMd4Bis save (IstMd4Bis obj){
		validaDati(obj)

		if (obj.id == null){
			obj.id = statoCivileService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su ISTM4B per id " + obj.id)
		return  istMd4BisRepository.save(obj)
	}

}
