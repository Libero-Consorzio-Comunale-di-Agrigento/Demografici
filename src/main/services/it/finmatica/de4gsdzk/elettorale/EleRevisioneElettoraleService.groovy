package it.finmatica.de4gsdzk.elettorale

import groovy.util.logging.Slf4j
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class EleRevisioneElettoraleService {

    EleRevisioneElettoraleRepository eleRevisioneElettoraleRepository

    EleRevisioneElettoraleService(EleRevisioneElettoraleRepository eleRevisioneElettoraleRepository) {
        this.eleRevisioneElettoraleRepository = eleRevisioneElettoraleRepository
    }

    Page<EleRevisioneElettorale> findAll(PageRequest p) {
        return eleRevisioneElettoraleRepository.findAll(p)
    }
}
