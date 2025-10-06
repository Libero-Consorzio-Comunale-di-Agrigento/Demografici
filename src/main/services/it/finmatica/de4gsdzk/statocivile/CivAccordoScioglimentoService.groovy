package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivAccordoScioglimentoRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivAccordoScioglimentoService {

	private final CivAccordoScioglimentoRepository civAccordoScioglimentoRepository

    CivAccordoScioglimentoService(CivAccordoScioglimentoRepository civAccordoScioglimentoRepository) {
		this.civAccordoScioglimentoRepository = civAccordoScioglimentoRepository
	}

	Page<CivAccordoScioglimento> listAll (PageRequest p){
		return civAccordoScioglimentoRepository.findAll(p)
	}

}
