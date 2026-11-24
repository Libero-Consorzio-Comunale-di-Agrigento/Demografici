package it.finmatica.de4gsdzk.elettorale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.certificazione.error.UtenteNonTerminalistaRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.statocivile.CivUfficiale
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class EleComponenteCommissioneService {

    EleComponenteCommissioneRepository eleComponenteCommissioneRepository

    EleComponenteCommissioneService(EleComponenteCommissioneRepository eleComponenteCommissioneRepository) {
        this.eleComponenteCommissioneRepository = eleComponenteCommissioneRepository
    }

    List<EleComponenteCommissione> listAllByCognomeNomeLike(String filtro){
        return eleComponenteCommissioneRepository.findAllByCognomeNomeLikeIgnoreCaseOrderByCodice((filtro?:""))
    }

}
