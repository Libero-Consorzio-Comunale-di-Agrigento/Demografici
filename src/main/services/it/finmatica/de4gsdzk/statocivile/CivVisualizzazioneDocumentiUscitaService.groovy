package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiUscitaRepository
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivVisualizzazioneDocumentiUscitaService implements IVisualizzazioneDocumentiService<CivVisualizzazioneDocumentiUscita> {

	private final CivVisualizzazioneDocumentiUscitaRepository civVisualizzazioneDocumentiUscitaRepository

    CivVisualizzazioneDocumentiUscitaService(CivVisualizzazioneDocumentiUscitaRepository civVisualizzazioneDocumentiUscitaRepository) {

		this.civVisualizzazioneDocumentiUscitaRepository = civVisualizzazioneDocumentiUscitaRepository
	}

	List<Integer> listAllAnniByRegistro(CivRegistroDocumentiBaseDomain registro) {
		if (registro) {
			return civVisualizzazioneDocumentiUscitaRepository.findAllAnniByIdRegistro(registro.id)
		}
		return []
	}

	Page<CivVisualizzazioneDocumentiUscita> listAllNonAssociatiByDTS(Boolean flagDtsPresente, String filtro, PageRequest p) {
		return civVisualizzazioneDocumentiUscitaRepository.findAllNonAssociatiByDTS(flagDtsPresente, SqlUtils.getFiltroLike(filtro), p)
	}

	Page<CivVisualizzazioneDocumentiUscita> listAllAssociatiByRegistro(
            CivRegistroDocumentiBaseDomain registro, Integer anno, Boolean flagNumerati,
            String filtro, PageRequest p) {
		if (registro!=null) {
			if (flagNumerati) {
				return civVisualizzazioneDocumentiUscitaRepository.findAllAssociatiNumeratiByIdRegistro(
						registro.id, anno, SqlUtils.getFiltroLike(filtro), p)
			} else {
				return civVisualizzazioneDocumentiUscitaRepository.findAllAssociatiNonNumeratiByIdRegistro(
						registro.id, anno, SqlUtils.getFiltroLike(filtro), p)
			}
		}
		return null
	}

}
