package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdMenuDittaRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class GsdMenuDittaService {

	private final GsdMenuDittaRepository gsdMenuDittaRepository

    GsdMenuDittaService(GsdMenuDittaRepository gsdMenuDittaRepository) {
		this.gsdMenuDittaRepository = gsdMenuDittaRepository
	}

	GsdMenuDitta getUniqueRecord(){
		List<GsdMenuDitta> l = list()
		if (l.size() == 1) {
			return l[0]
		}
		return null
	}

	List<GsdMenuDitta> list () {
		return gsdMenuDittaRepository.findAll()
	}

}