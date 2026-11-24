package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivFormulaAggiuntivaService {

    private final GsdService gsdService

    private final GsdValidazioneTestoService gsdValidazioneTestoService

    private final CivFormulaAggiuntivaRepository civFormulaAggiuntivaRepository

    CivFormulaAggiuntivaService(CivFormulaAggiuntivaRepository civFormulaAggiuntivaRepository, GsdService gsdService,
                                GsdValidazioneTestoService gsdValidazioneTestoService){
        this.civFormulaAggiuntivaRepository = civFormulaAggiuntivaRepository
        this.gsdService = gsdService
        this.gsdValidazioneTestoService = gsdValidazioneTestoService
    }

    CivFormulaAggiuntiva get (Long id){
        return civFormulaAggiuntivaRepository.findById(id)
    }

    Page<CivFormulaAggiuntiva> listAllByTipoAtto(Integer tipoAtto, Pageable pageable) {
        if (tipoAtto) {
            return civFormulaAggiuntivaRepository.findAllByTipoAtto(tipoAtto, pageable)
        }
        return null
    }

    private void validaDati(CivFormulaAggiuntiva obj) {
        ValidationUtils.validaDatiObbligatori(obj)

        gsdValidazioneTestoService.checkWrongVar(obj.testo, gsdService.listVariabili(CivFormulaAggiuntiva.class, obj.tipoAtto))
    }

    CivFormulaAggiuntiva save (CivFormulaAggiuntiva obj) {

        validaDati(obj)

        if (obj.id == null){
            obj.id = gsdService.getIdFromSequence(obj)
        }
        log.info("Lancio salvataggio su CIVFAA per id " + obj.id)
        return civFormulaAggiuntivaRepository.save(obj)
    }

}
