package it.finmatica.de4gsdzk.anpr

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anpr.AnprCertificabilitaRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnprCertificabilitaService {

    private final AnprCertificabilitaRepository anprCertificabilitaRepository

    AnprCertificabilitaService(AnprCertificabilitaRepository anprCertificabilitaRepository) {
        this.anprCertificabilitaRepository = anprCertificabilitaRepository
    }

    List<AnprCertificabilita> listAll() {
        return anprCertificabilitaRepository.findAll()
    }
}
