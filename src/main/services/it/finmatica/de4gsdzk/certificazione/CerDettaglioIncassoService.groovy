package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerDettaglioIncassoService {

    private final CerDettaglioIncassoRepository cerDettaglioIncassoRepository

    CerDettaglioIncassoService(CerDettaglioIncassoRepository cerDettaglioIncassoRepository) {
        this.cerDettaglioIncassoRepository = cerDettaglioIncassoRepository
    }

    List<Map<String, Object>> findAllDettaglioIncasso(Date dataInizio, Date dataFine) {
        return cerDettaglioIncassoRepository.findAllDettaglioIncasso(dataInizio, dataFine)
    }
}
