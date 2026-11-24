package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class IstMd4BisService {

	private final GsdService gsdService

    private final CivValidazioneModelloIstatService civValidazioneModelloIstatService

	private final IstMd4BisRepository istMd4BisRepository

    IstMd4BisService(IstMd4BisRepository istMd4BisRepository, GsdService gsdService,
                     CivValidazioneModelloIstatService civValidazioneModelloIstatService) {

        this.istMd4BisRepository = istMd4BisRepository
		this.gsdService = gsdService
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
			obj.id = gsdService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su ISTM4B per id " + obj.id)
		return  istMd4BisRepository.save(obj)
	}

}
