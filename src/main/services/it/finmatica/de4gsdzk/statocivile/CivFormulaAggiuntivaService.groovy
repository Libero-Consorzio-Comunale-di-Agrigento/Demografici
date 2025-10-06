package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAggiuntivaRepository
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivFormulaAggiuntivaService {

    private final StatoCivileService statoCivileService

    private final GsdValidazioneTestoService gsdValidazioneTestoService

    private final CivFormulaAggiuntivaRepository civFormulaAggiuntivaRepository

    CivFormulaAggiuntivaService(CivFormulaAggiuntivaRepository civFormulaAggiuntivaRepository, StatoCivileService statoCivileService,
                                GsdValidazioneTestoService gsdValidazioneTestoService){
        this.civFormulaAggiuntivaRepository = civFormulaAggiuntivaRepository
        this.statoCivileService = statoCivileService
        this.gsdValidazioneTestoService = gsdValidazioneTestoService
    }

    CivFormulaAggiuntiva get (Long id){
        return civFormulaAggiuntivaRepository.findById(id)
    }

    Page<CivFormulaAggiuntiva> listAllByTipoAttoOrderBySequenza(Integer tipoAtto, Pageable pageable) {
        if (tipoAtto) {
            return civFormulaAggiuntivaRepository.findAllByTipoAttoOrderBySequenza(tipoAtto, pageable)
        }
        return null
    }

    private void validaDati(CivFormulaAggiuntiva obj) {
        ValidationUtils.validaDatiObbligatori(obj)

        gsdValidazioneTestoService.checkWrongVar(obj.testo, statoCivileService.listVariabili(CivFormulaAggiuntiva.class, obj.tipoAtto))
    }

    CivFormulaAggiuntiva save (CivFormulaAggiuntiva obj) {

        validaDati(obj)

        if (obj.id == null){
            obj.id = statoCivileService.getIdFromSequence(obj)
        }
        log.info("Lancio salvataggio su CIVFAA per id " + obj.id)
        return civFormulaAggiuntivaRepository.save(obj)
    }

}
