package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerCodiceControlloRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerCodiceControlloService {

    private final CerCodiceControlloRepository cerCodiceControlloRepository

    CerCodiceControlloService(CerCodiceControlloRepository cerCodiceControlloRepository) {
        this.cerCodiceControlloRepository = cerCodiceControlloRepository
    }

    Page<CerCodiceControllo> listAll(PageRequest pr) {
        return cerCodiceControlloRepository.findAll(pr)
    }

}
