package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CompetenzaService
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerCategoriaTipoCertificatoService {

	private final CerCategoriaTipoCertificatoRepository categoriaTipoCertificatoRepository
	private final CerTipoCertificatoService cerTipoCertificatoService
	private final CompetenzaService competenzaService

	CerCategoriaTipoCertificatoService(CerCategoriaTipoCertificatoRepository categoriaTipoCertificatoRepository,
									   CerTipoCertificatoService cerTipoCertificatoService,
									   CompetenzaService competenzaService) {
		this.categoriaTipoCertificatoRepository = categoriaTipoCertificatoRepository
		this.cerTipoCertificatoService = cerTipoCertificatoService
		this.competenzaService = competenzaService
	}

	List<CerCategoriaTipoCertificato> listAll() {
		Sort s = new Sort(Sort.Direction.ASC, "sequenza")
		return categoriaTipoCertificatoRepository.findAll(s)
	}

	List<CerCategoriaTipoCertificato> listAllByAnagrafeFiltroList(List<CerAnagrafeFiltro> anagrafeFiltroList, boolean includiSoloStatoCivile = false) {
		Set<ECompetenzaCertificazione> competenzaCertificazioneSet = competenzaService.getCompetenzeCertificazioneByRuoli()

		Map params = [
				anagrafeFiltroList         : anagrafeFiltroList,
				competenzaCertificazioneSet: competenzaCertificazioneSet,
				includiSoloStatoCivile         : includiSoloStatoCivile,
				order                      : SortUtils.sequenzaAsc
		]

		return categoriaTipoCertificatoRepository.listByParams(params)
	}
}
