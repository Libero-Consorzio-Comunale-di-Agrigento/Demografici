package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerStatisticaCertificatoEmessoService {

    private final CerStatisticaCertificatoEmessoRepository cerStatisticaCertificatoEmessoRepository

    CerStatisticaCertificatoEmessoService(CerStatisticaCertificatoEmessoRepository cerStatisticaCertificatoEmessoRepository) {
        this.cerStatisticaCertificatoEmessoRepository = cerStatisticaCertificatoEmessoRepository
    }

    List<Map<String, Object>> findAllDettaglioTerminalisti(Date dataInizio, Date dataFine) {
        return cerStatisticaCertificatoEmessoRepository.findAllDettaglioTerminalisti(dataInizio, dataFine)
    }
}
