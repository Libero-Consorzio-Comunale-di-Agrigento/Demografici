package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.ansc.AnscUtenteRepository
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscUtenteService {

    private final UtenteCustomService utenteCustomService

    private final AnscUtenteRepository anscUtenteRepository

    AnscUtenteService(AnscUtenteRepository anscUtenteRepository, UtenteCustomService utenteCustomService) {
        this.anscUtenteRepository = anscUtenteRepository
        this.utenteCustomService = utenteCustomService
    }

    AnscUtente get (String id){
        return anscUtenteRepository.findById(id)
    }

    AnscUtente getAnscUtenteCorrente(){
        return get(utenteCustomService.loggedUserId)
    }

    private void validaDati(AnscUtente obj){
        if (TestoUtils.isVuoto(obj.id)){
            throw new CampoMandatoryRuntimeException()
        }
    }

    AnscUtente save (AnscUtente obj){
        validaDati(obj)

        return anscUtenteRepository.save(obj)
    }

}
