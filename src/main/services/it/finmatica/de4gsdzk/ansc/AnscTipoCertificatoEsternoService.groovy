package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscTipoCertificatoEsternoRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscTipoCertificatoEsternoService {

    private final AnscTipoCertificatoEsternoRepository anscTipoCertificatoEsternoRepository

    AnscTipoCertificatoEsternoService(AnscTipoCertificatoEsternoRepository anscTipoCertificatoEsternoRepository) {
        this.anscTipoCertificatoEsternoRepository = anscTipoCertificatoEsternoRepository
    }

    Page<AnscTipoCertificatoEsterno> listAllByDescrizione(String filtro, PageRequest p) {
        return anscTipoCertificatoEsternoRepository.findAllByDescrizioneLikeIgnoreCase(filtro, p)
    }
}
