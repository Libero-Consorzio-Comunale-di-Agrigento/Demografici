package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivCittadinanzaSelectRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivCittadinanzaSelectService {

	private final CivCittadinanzaSelectRepository civCittadinanzaSelectRepository

    CivCittadinanzaSelectService(CivCittadinanzaSelectRepository civCittadinanzaSelectRepository) {
		this.civCittadinanzaSelectRepository = civCittadinanzaSelectRepository
	}

    Page<CivCittadinanzaSelect> listAllByCategoria (String codiceCategoria, PageRequest p){
        if (codiceCategoria){
            return civCittadinanzaSelectRepository.findAllByCodiceCategoria(codiceCategoria, p)
        }
        return null
    }

}
