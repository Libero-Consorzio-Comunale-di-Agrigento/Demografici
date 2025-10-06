package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivMinutaRepository
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivMinutaService {

    private final StatoCivileService statoCivileService

    private final GsdValidazioneTestoService gsdValidazioneTestoService

	private final CivMinutaRepository civMinutaRepository

    CivMinutaService(CivMinutaRepository civMinutaRepository, StatoCivileService statoCivileService, GsdValidazioneTestoService gsdValidazioneTestoService) {

        this.civMinutaRepository = civMinutaRepository
        this.statoCivileService = statoCivileService
        this.gsdValidazioneTestoService = gsdValidazioneTestoService
	}

	CivMinuta get (Long id){
		return civMinutaRepository.findById(id)
	}

    CivMinuta getWithTesto (Long id){
        return civMinutaRepository.findWithTestoById(id)
    }

    Page<CivMinuta> listAllByTipoAttoAndDescrizioneLike(Integer tipoAtto, String filtro, PageRequest p){
        if (tipoAtto == null){
            return null
        }
        if ( (filtro?.trim()?:"") != "") {
            return civMinutaRepository.findAllByTipoAttoAndDescrizioneLike(tipoAtto, filtro, p)
        } else {
            return civMinutaRepository.findAllByTipoAtto(tipoAtto, p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, CivMinuta obj) {
        ValidationUtils.validaDatiObbligatori(obj)

        if (tipoOperazione.isInsert()){
            long n = civMinutaRepository.countByTipoAttoAndCodice(obj.tipoAtto, obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Minuta_Duplicata)
            }
        }

        gsdValidazioneTestoService.checkWrongVar(obj.testo.clob, statoCivileService.listVariabili(CivTestoMinuta.class, obj.tipoAtto))
    }
    
    CivMinuta save (ETipoOperazione tipoOperazione, CivMinuta obj) {
        validaDati(tipoOperazione, obj)

        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = statoCivileService.getIdFromSequence(obj)
        }
        if (obj.testo.id == null) {
            // solo in caso di inserimento
            obj.testo.id = statoCivileService.getIdFromSequence(obj.testo)
        }
        obj.testo.codice = obj.codice

        log.info("Lancio salvataggio su CIVDMI per id " + obj.id)
        return civMinutaRepository.save(obj)
    }

}
