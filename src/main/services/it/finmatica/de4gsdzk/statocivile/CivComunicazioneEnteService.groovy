package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneEnteRepository
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service

import javax.transaction.Transactional

@Slf4j
@Service
@Transactional
class CivComunicazioneEnteService {

    private CivComunicazioneEnteRepository civComunicazioneEnteRepository

    private StatoCivileService statoCivileService

    CivComunicazioneEnteService(CivComunicazioneEnteRepository civComunicazioneEnteRepository, StatoCivileService statoCivileService) {
        this.civComunicazioneEnteRepository = civComunicazioneEnteRepository
        this.statoCivileService = statoCivileService
    }

    CivComunicazioneEnte get(Long id) {
        civComunicazioneEnteRepository.findById(id)
    }

    /**
     * Carica tutte le comunicazioni ente per tipo di atto. se 0, carica le
     * comunicazione per annotazione
     *
     * @param tipoAtto il tipo di atto, oppure 0
     * @param pageable
     * @return la lista paginata
     */
    Page<CivComunicazioneEnte> listAllByTipoAtto(Integer tipoAtto, Pageable pageable) {
        if (tipoAtto != null){
            return civComunicazioneEnteRepository.findAllByTipoAtto(tipoAtto, pageable)
        }
        return null
    }

    Page<CivComunicazioneEnte> listAllByTipoAttoAndComunicazione(Integer tipoAtto, CivComunicazione comunicazione, Pageable pageable) {
        civComunicazioneEnteRepository.findAllByTipoAttoAndComunicazione(tipoAtto, comunicazione, pageable)
    }

    void validaDati(CivComunicazioneEnte obj) {
        ValidationUtils.validaDatiObbligatori(obj)

        // Controlla l'unicità
        CivComunicazioneEnte esistente = civComunicazioneEnteRepository.findByTipoAttoAndComunicazioneAndEnte(obj.tipoAtto, obj.comunicazione, obj.ente)
        if (esistente && esistente.id!=obj.id) {
            throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Relazione_Duplicata)
        }
    }

    CivComunicazioneEnte save(CivComunicazioneEnte obj) {
        validaDati(obj)

        if (obj.id==null) {
            obj.id = statoCivileService.getIdFromSequence(obj)
        }

        log.info("Lancio salvataggio su CIVDDC per id " + obj.id)
        civComunicazioneEnteRepository.save(obj)
    }

    void delete(CivComunicazioneEnte obj) {
        civComunicazioneEnteRepository.delete(obj)
    }
}
