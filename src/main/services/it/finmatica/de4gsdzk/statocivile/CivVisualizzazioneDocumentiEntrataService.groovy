package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiEntrataRepository
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivVisualizzazioneDocumentiEntrataService implements IVisualizzazioneDocumentiService<CivVisualizzazioneDocumentiEntrata> {

	private final CivVisualizzazioneDocumentiEntrataRepository civVisualizzazioneDocumentiEntrataRepository

	CivVisualizzazioneDocumentiEntrataService(CivVisualizzazioneDocumentiEntrataRepository civVisualizzazioneDocumentiEntrataRepository) {
		this.civVisualizzazioneDocumentiEntrataRepository = civVisualizzazioneDocumentiEntrataRepository
	}

	List<Integer> listAllAnniByRegistro(CivRegistroDocumentiBaseDomain registro) {
		if (registro) {
			return civVisualizzazioneDocumentiEntrataRepository.findAllAnniByIdRegistro(registro.id)
		}
		return []
	}

	Page<CivVisualizzazioneDocumentiEntrata> listAllAssociatiByRegistro(
			CivRegistroDocumentiBaseDomain registro, Integer anno, Boolean flagNumerati,
			String filtro, PageRequest p) {
		if (registro!=null) {
			if (flagNumerati) {
				return civVisualizzazioneDocumentiEntrataRepository.findAllNumeratiByIdRegistro(
						registro.id, anno, SqlUtils.getFiltroLike(filtro), p)
			} else {
				return civVisualizzazioneDocumentiEntrataRepository.findAllNonNumeratiByIdRegistro(
						registro.id, anno, SqlUtils.getFiltroLike(filtro), p)
			}
		}
		return null
	}

}
