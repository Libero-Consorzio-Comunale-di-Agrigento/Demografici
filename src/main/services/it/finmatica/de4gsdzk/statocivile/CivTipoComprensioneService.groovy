package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivTipoComprensioneRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivTipoComprensioneService {

    private final CivTipoComprensioneRepository civTipoComprensioneRepository

    CivTipoComprensioneService(CivTipoComprensioneRepository civTipoComprensioneRepository) {
        this.civTipoComprensioneRepository = civTipoComprensioneRepository
    }

    CivTipoComprensione get(String id){
        return civTipoComprensioneRepository.findById(id)
    }

    CivTipoComprensione getDefault(){
        return civTipoComprensioneRepository.findById("00")
    }

    List<CivTipoComprensione> listAll() {
        return civTipoComprensioneRepository.findAll()
    }
}
