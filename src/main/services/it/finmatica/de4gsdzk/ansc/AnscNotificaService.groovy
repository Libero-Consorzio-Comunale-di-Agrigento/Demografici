package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscNotificaRepository
import it.finmatica.de4gsdzk.utils.RicercaNotifica
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscNotificaService {

    private final AnscNotificaRepository anscNotificaRepository

    AnscNotificaService(AnscNotificaRepository anscNotificaRepository) {
        this.anscNotificaRepository = anscNotificaRepository
    }

    AnscNotifica get (Long id){
        return anscNotificaRepository.findById(id)
    }

    Page<AnscNotifica> listAllByRicerca(RicercaNotifica ricerca, Pageable pageable) {
        return anscNotificaRepository.listAllByRicerca(ricerca, pageable)
    }

    AnscNotifica save(AnscNotifica obj) {
        return anscNotificaRepository.save(obj)
    }

}
