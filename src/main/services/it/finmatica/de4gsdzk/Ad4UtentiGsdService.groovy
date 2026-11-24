package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class Ad4UtentiGsdService {

    private final Ad4UtentiGsdRepository ad4UtentiGsdRepository

    Ad4UtentiGsdService(Ad4UtentiGsdRepository ad4UtentiGsdRepository) {
        this.ad4UtentiGsdRepository = ad4UtentiGsdRepository
    }

    List<Ad4UtentiGsd> listAll() {
        return ad4UtentiGsdRepository.findAll()
    }
}
