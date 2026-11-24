package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.EGruppo
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CampiCaratteriSpecialiDizionarioService {

    private final CampiCaratteriSpecialiDizionarioRepository campiCaratteriSpecialiDizionarioRepository

    CampiCaratteriSpecialiDizionarioService(CampiCaratteriSpecialiDizionarioRepository campiCaratteriSpecialiDizionarioRepository) {
        this.campiCaratteriSpecialiDizionarioRepository = campiCaratteriSpecialiDizionarioRepository
    }

    List<CampoCaratteriSpecialiDizionario> findAllByGruppoIn(List<EGruppo> gruppo) {
        return campiCaratteriSpecialiDizionarioRepository.findAllByGruppoIn(gruppo)
    }
}
