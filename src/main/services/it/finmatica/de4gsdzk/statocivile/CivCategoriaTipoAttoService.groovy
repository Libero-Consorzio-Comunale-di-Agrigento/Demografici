package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAttoRepository
import it.finmatica.de4gsdzk.utils.ENaturaAtto
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivCategoriaTipoAttoService {

	private final CivCategoriaTipoAttoRepository civCategoriaTipoAttoRepository

	private final ArcParametroService arcParametroService

	CivCategoriaTipoAttoService(CivCategoriaTipoAttoRepository civCategoriaTipoAttoRepository, ArcParametroService arcParametroService) {
		this.civCategoriaTipoAttoRepository = civCategoriaTipoAttoRepository
		this.arcParametroService = arcParametroService
	}

	List<CivCategoriaTipoAtto> listAllByIdIn(List<Integer> ids) {
		return civCategoriaTipoAttoRepository.findAllByIdIn(ids)
	}

	List<CivCategoriaTipoAtto> listAllByTipoAttoAndParteAndSerieAndNatura(Integer tipoAtto, Integer parte, String serie, ENaturaAtto natura, Map params=[:]){
		Boolean flagAnsc = arcParametroService.isIntegrazioneAnscAttiva() ?: null
		params.put("flagAnsc", flagAnsc)
		return civCategoriaTipoAttoRepository.findAllByTipoAttoAndParteAndSerieAndNatura(tipoAtto, parte, serie, natura, params)
	}

	List<CivCategoriaTipoAtto> listAllByTipoAttoAndFlagFormuleIsNullOrderByDescrizione(Integer tipoAtto){
		Boolean flagAnsc = arcParametroService.isIntegrazioneAnscAttiva() ?: null
		return civCategoriaTipoAttoRepository.findAllByTipoAttoAndFlagFormuleIsNullAndFlagAnscOrderByDescrizione(tipoAtto, flagAnsc)
	}
}
