package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivNumerazioneDocumentiUscitaService {

	private final GsdService gsdService

	private final CivNumerazioneDocumentiUscitaRepository civNumerazioneDocumentiUscitaRepository

    CivNumerazioneDocumentiUscitaService(CivNumerazioneDocumentiUscitaRepository civNumerazioneDocumentiUscitaRepository,
                                         GsdService gsdService) {

		this.civNumerazioneDocumentiUscitaRepository = civNumerazioneDocumentiUscitaRepository
		this.gsdService = gsdService
	}

	List<CivNumerazioneDocumentiUscita> listAllByIdRegistro(Integer idRegistro) {
		return civNumerazioneDocumentiUscitaRepository.findAllByIdRegistro(idRegistro)
	}

	CivNumerazioneDocumentiUscita getByAnnoAndRegistro(Integer anno, CivRegistroDocumentiUscita rdu) {
		civNumerazioneDocumentiUscitaRepository.findByAnnoAndRegistro(anno, rdu)
	}

	CivNumerazioneDocumentiUscita getOrCreateByAnnoAndRegistro(Integer anno, CivRegistroDocumentiUscita rdu){
		CivNumerazioneDocumentiUscita d = getByAnnoAndRegistro(anno, rdu)
		if (!(d)){
			d = new CivNumerazioneDocumentiUscita(numero: new Integer(0), anno: anno, registro: rdu)
		}
		return d
	}

	private void validaDati(CivNumerazioneDocumentiUscita obj) {
		if ( (obj.registro?.id == null) || (obj.anno == null) || (obj.numero == null)){
			throw new CampoMandatoryRuntimeException()
		}
	}

	CivNumerazioneDocumentiUscita save (CivNumerazioneDocumentiUscita obj){
		validaDati(obj)

		if (obj.id == null) {
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}

		log.info("Lancio salvataggio su CIVNDU per id " + obj.id)
		CivNumerazioneDocumentiUscita saved = civNumerazioneDocumentiUscitaRepository.save(obj)
		return saved
	}

}
