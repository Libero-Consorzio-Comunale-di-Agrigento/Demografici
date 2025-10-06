package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivFormulaChiusuraRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivFormulaChiusuraService {

	private final CivFormulaChiusuraRepository civFormulaChiusuraRepository

    CivFormulaChiusuraService(CivFormulaChiusuraRepository civFormulaChiusuraRepository) {
		this.civFormulaChiusuraRepository = civFormulaChiusuraRepository
	}

    List<CivFormulaChiusura> listAllOrderById() {
        return civFormulaChiusuraRepository.findAllByOrderById()
    }

}
