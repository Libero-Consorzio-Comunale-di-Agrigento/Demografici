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
class IstMd3MatrimonioService {

	private final GsdService gsdService

	private final CivValidazioneModelloIstatService civValidazioneModelloIstatService

	private final IstMd3MatrimonioRepository istMd3MatrimonioRepository

	IstMd3MatrimonioService(IstMd3MatrimonioRepository istMd3MatrimonioRepository, CivValidazioneModelloIstatService civValidazioneModelloIstatService,
                            GsdService gsdService) {

		this.istMd3MatrimonioRepository = istMd3MatrimonioRepository
		this.civValidazioneModelloIstatService = civValidazioneModelloIstatService
		this.gsdService = gsdService
	}

	IstMd3Matrimonio get(Long id){
		return istMd3MatrimonioRepository.findById(id)
	}

	IstMd3Matrimonio getByUkAtto(String identificativoAtto) {
		return istMd3MatrimonioRepository.findByUkAtto(identificativoAtto)
	}

	private void validaDati(IstMd3Matrimonio obj){
		civValidazioneModelloIstatService.checkEstremiAtto(obj)

		civValidazioneModelloIstatService.checkChiusuraProvvisorio(obj)

		if (obj.flagCompleto) {
			if ( (obj.rito == null) || (obj.statoCivile1 == null) || (obj.statoCivile2 == null) ||
				 (obj.nazionalitaItaliana1 == null) || (obj.nazionalitaItaliana2 == null) ) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_modello_istat"))
			}
		}
	}

	IstMd3Matrimonio save (IstMd3Matrimonio obj){
		validaDati(obj)

		if (obj.id == null){
			obj.id = gsdService.getIdFromSequence(obj, "ISTMD3")
		}
		log.info("Lancio salvataggio su ISTMD3 per id " + obj.id)
		return  istMd3MatrimonioRepository.save(obj)
	}

}
