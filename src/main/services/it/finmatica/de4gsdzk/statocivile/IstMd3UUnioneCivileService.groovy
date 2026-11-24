package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class IstMd3UUnioneCivileService {

	private final GsdService gsdService

	private final CivValidazioneModelloIstatService civValidazioneModelloIstatService

	private final IstMd3UUnioneCivileRepository istMd3UUnioneCivileRepository

	IstMd3UUnioneCivileService(IstMd3UUnioneCivileRepository istMd3UUnioneCivileRepository, GsdService gsdService,
                               CivValidazioneModelloIstatService civValidazioneModelloIstatService) {

		this.istMd3UUnioneCivileRepository = istMd3UUnioneCivileRepository
		this.gsdService = gsdService
		this.civValidazioneModelloIstatService = civValidazioneModelloIstatService
	}

	IstMd3UUnioneCivile get(Long id){
		return istMd3UUnioneCivileRepository.findById(id)
	}

	IstMd3UUnioneCivile getByUkAtto(String identificativoAtto) {
		return istMd3UUnioneCivileRepository.findByUkAtto(identificativoAtto)
	}

	private void validaDati(IstMd3UUnioneCivile obj){
		civValidazioneModelloIstatService.checkEstremiAtto(obj)

		civValidazioneModelloIstatService.checkChiusuraProvvisorio(obj)

		if (obj.flagCompleto) {
			if ( (obj.statoCivile1 == null) || (obj.statoCivile2 == null) ) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_modello_istat"))
			}
		}
	}

	IstMd3UUnioneCivile save (IstMd3UUnioneCivile obj){
		validaDati(obj)

		if (obj.id == null){
			obj.id = gsdService.getIdFromSequence(obj, "ISTMDU")
		}
		log.info("Lancio salvataggio su ISTMDU per id " + obj.id)
		return  istMd3UUnioneCivileRepository.save(obj)
	}

}
