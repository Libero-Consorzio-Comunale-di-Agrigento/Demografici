package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivAccordoDivorzioRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivAccordoDivorzioService {

	private final CivAccordoDivorzioRepository civAccordoDivorzioRepository

    CivAccordoDivorzioService(CivAccordoDivorzioRepository civAccordoDivorzioRepository) {
		this.civAccordoDivorzioRepository = civAccordoDivorzioRepository
	}

	Page<CivAccordoDivorzio> listAll (PageRequest p){
		return civAccordoDivorzioRepository.findAll(p)
	}

}
