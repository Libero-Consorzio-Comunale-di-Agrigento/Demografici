package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivEnteRepository
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivEnteService {

	private final CivEnteRepository civEnteRepository

    CivEnteService(CivEnteRepository civEnteRepository) {
		this.civEnteRepository = civEnteRepository
	}

	CivEnte get (Integer id){
		return civEnteRepository.findById(id)
	}

	List<CivEnte> listAll(Sort s) {
		return civEnteRepository.findAll(s)
	}

	List<CivEnte> listAllByTipoEnteDestinatario(ETipoEnteDestinatario tipoEnteDestinatario) {
		return civEnteRepository.findAllByTipoEnteDestinatario(tipoEnteDestinatario, new Sort(SortUtils.descrizioneAsc))
	}

	Page<CivEnte> listAllByDescrizioneOrPecLike (String filtro, PageRequest p) {
		if ( (filtro?.trim()?:"") != "") {
			return civEnteRepository.findAllByDescrizioneLikeIgnoreCaseOrPecLikeIgnoreCase(filtro, filtro, p)
		} else {
			return civEnteRepository.findAll(p)
		}
	}

	List<CivEnte> listAllByTipoEnteDestinatarioAndIdNotIn(ETipoEnteDestinatario tipoEnteDestinatario, List<Integer> listaId) {
		return civEnteRepository.findAllByTipoEnteDestinatarioAndIdNotInOrderByDescrizione(tipoEnteDestinatario, listaId)
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivEnte obj) {
		ValidationUtils.validaDatiObbligatori(obj)

		if (tipoOperazione.isInsert()){
			long n = civEnteRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Ente_Duplicato)
			}
		}
	}

	CivEnte save (ETipoOperazione tipoOperazione, CivEnte obj) {

		validaDati(tipoOperazione, obj)

		log.info("Lancio salvataggio su CIVDEN_V per id " + obj.id)
		return civEnteRepository.save(obj)
	}

}
