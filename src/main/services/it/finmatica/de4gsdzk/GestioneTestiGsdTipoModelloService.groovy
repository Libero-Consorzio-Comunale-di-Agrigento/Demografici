package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdTipoModelloRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class GestioneTestiGsdTipoModelloService {

    GestioneTestiGsdTipoModelloRepository gestioneTestiGsdTipoModelloRepository

    GestioneTestiGsdTipoModelloService(GestioneTestiGsdTipoModelloRepository gestioneTestiGsdTipoModelloRepository) {
        this.gestioneTestiGsdTipoModelloRepository = gestioneTestiGsdTipoModelloRepository
    }

    GestioneTestiGsdTipoModello get(String id) {
        return gestioneTestiGsdTipoModelloRepository.findByCodice(id)
    }
}
