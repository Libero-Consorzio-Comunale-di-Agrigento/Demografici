package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CampiCaratteriSpecialiService {

    private final CampiCaratteriSpecialiRepository campiCaratteriSpecialiRepository
    private final CerTerminalistaService cerTerminalistaService

    CampiCaratteriSpecialiService(CampiCaratteriSpecialiRepository campiCaratteriSpecialiRepository, CerTerminalistaService cerTerminalistaService) {
        this.campiCaratteriSpecialiRepository = campiCaratteriSpecialiRepository
        this.cerTerminalistaService = cerTerminalistaService
    }

    List<CampoCaratteriSpeciali> findAllByTabellaAndIdRif(String tabella, Object idRif) {
        return campiCaratteriSpecialiRepository.findAllByTabellaAndIdRifOrderByIdAsc(tabella, idRif)
    }

    void saveOrUpdate(CampoCaratteriSpeciali campo) {
        campo.terminalista = cerTerminalistaService.getTerminalistaUtente()
        campiCaratteriSpecialiRepository.save(campo)
    }

    void delete(CampoCaratteriSpeciali campo) {
        campiCaratteriSpecialiRepository.delete(campo)
    }
}
