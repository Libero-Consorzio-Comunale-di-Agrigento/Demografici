package it.finmatica.de4gsdzk.anpr

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anpr.AnprTipoCertificatoEsternoRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnprTipoCertificatoEsternoService {

    private final AnprTipoCertificatoEsternoRepository anprTipoCertificatoEsternoRepository

    AnprTipoCertificatoEsternoService(AnprTipoCertificatoEsternoRepository anprTipoCertificatoEsternoRepository) {
        this.anprTipoCertificatoEsternoRepository = anprTipoCertificatoEsternoRepository
    }

    Page<AnprTipoCertificatoEsterno> listAllByDescrizione(String filtro, PageRequest p) {
        return anprTipoCertificatoEsternoRepository.findAllByDescrizioneLikeIgnoreCase(filtro, p)
    }
}
