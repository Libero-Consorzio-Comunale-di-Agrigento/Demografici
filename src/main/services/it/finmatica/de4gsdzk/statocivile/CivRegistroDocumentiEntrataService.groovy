package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivRegistroDocumentiEntrataService implements IRegistroDocumentiService<CivRegistroDocumentiEntrata, CivNumerazioneDocumentiEntrata> {

	private final CivRegistroDocumentiEntrataRepository civRegistroDocumentiEntrataRepository

	private final CivNumerazioneDocumentiEntrataService civNumerazioneDocumentiEntrataService

	CivRegistroDocumentiEntrataService(CivRegistroDocumentiEntrataRepository civRegistroDocumentiEntrataRepository, CivNumerazioneDocumentiEntrataService civNumerazioneDocumentiEntrataService) {
		this.civNumerazioneDocumentiEntrataService = civNumerazioneDocumentiEntrataService
		this.civRegistroDocumentiEntrataRepository = civRegistroDocumentiEntrataRepository
	}

	Tuple2<CivRegistroDocumentiEntrata, Collection<CivNumerazioneDocumentiEntrata>> get (Integer id){
		new Tuple2<CivRegistroDocumentiEntrata, Collection<CivNumerazioneDocumentiEntrata>>(
				civRegistroDocumentiEntrataRepository.findById(id),
				civNumerazioneDocumentiEntrataService.listAllByIdRegistro(id)
		)
	}

	List<CivRegistroDocumentiEntrata> listAll() {
		return civRegistroDocumentiEntrataRepository.findAll(new Sort(SortUtils.descrizioneAsc))
	}

	Page<CivRegistroDocumentiEntrata> listAllByDescrizioneLike (String filtro, PageRequest p){
		if ( (filtro?.trim()?:"") != "") {
			return civRegistroDocumentiEntrataRepository.findAllByDescrizioneLikeIgnoreCase(filtro, p)
		} else {
			return civRegistroDocumentiEntrataRepository.findAll(p)
		}
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivRegistroDocumentiEntrata obj){
		ValidationUtils.validaDatiObbligatori(obj)

		if ( (obj.descrizione?:"") == ""){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
		}

		if (tipoOperazione.isInsert()){
			long n = civRegistroDocumentiEntrataRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Registro_Duplicato"))
			}
		}
	}

	CivRegistroDocumentiEntrata save (ETipoOperazione tipoOperazione, CivRegistroDocumentiEntrata obj, LinkedHashSet<CivNumerazioneDocumentiEntrata> listaNumeriDocumenti){
		validaDati(tipoOperazione, obj)

		for (CivNumerazioneDocumentiEntrata d : listaNumeriDocumenti) {
			civNumerazioneDocumentiEntrataService.save(d)
		}

		log.info("Lancio salvataggio su CIVRDE per id " + obj.id)
		return civRegistroDocumentiEntrataRepository.save(obj)
	}

}
