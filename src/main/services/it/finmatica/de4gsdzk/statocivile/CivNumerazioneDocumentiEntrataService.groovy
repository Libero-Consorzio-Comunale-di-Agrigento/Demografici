package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivNumerazioneDocumentiEntrataRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivNumerazioneDocumentiEntrataService {

	private final StatoCivileService statoCivileService

	private final CivNumerazioneDocumentiEntrataRepository civNumerazioneDocumentiEntrataRepository

    CivNumerazioneDocumentiEntrataService(CivNumerazioneDocumentiEntrataRepository civNumerazioneDocumentiEntrataRepository,
                                          StatoCivileService statoCivileService) {

		this.civNumerazioneDocumentiEntrataRepository = civNumerazioneDocumentiEntrataRepository
		this.statoCivileService = statoCivileService
	}

	List<CivNumerazioneDocumentiEntrata> listAllByIdRegistro(Integer idRegistro) {
		return civNumerazioneDocumentiEntrataRepository.findAllByIdRegistro(idRegistro)
	}

	CivNumerazioneDocumentiEntrata getByAnnoAndRegistro(Integer anno, CivRegistroDocumentiEntrata rde) {
		civNumerazioneDocumentiEntrataRepository.findByAnnoAndRegistro(anno, rde)
	}

	CivNumerazioneDocumentiEntrata getOrCreateByAnnoAndRegistro(Integer anno, CivRegistroDocumentiEntrata rde){
		CivNumerazioneDocumentiEntrata d = getByAnnoAndRegistro(anno, rde)
		if (!(d)){
			d = new CivNumerazioneDocumentiEntrata(numero: new Integer(0), anno: anno, registro: rde)
		}
		return d
	}

	private void validaDati(CivNumerazioneDocumentiEntrata obj) {
		if ( (obj.registro == null) || (obj.registro?.id == null) || (obj.anno == null) || (obj.numero == null)){
			throw new CampoMandatoryRuntimeException()
		}
	}

	CivNumerazioneDocumentiEntrata save (CivNumerazioneDocumentiEntrata obj){
		validaDati(obj)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = statoCivileService.getIdFromSequence(obj)
		}

		log.info("Lancio salvataggio su CIVNDE per id " + obj.id)
		CivNumerazioneDocumentiEntrata saved = civNumerazioneDocumentiEntrataRepository.save(obj)
		return saved
	}

}
