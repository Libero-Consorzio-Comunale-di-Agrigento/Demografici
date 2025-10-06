package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivDisposizioniAnticipateTrattamentoTipoAttoRepository
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivDisposizioniAnticipateTrattamentoTipoAttoService {

    private final CivDisposizioniAnticipateTrattamentoTipoAttoRepository civDisposizioniAnticipateTrattamentoTipoAttoRepository

    CivDisposizioniAnticipateTrattamentoTipoAttoService(CivDisposizioniAnticipateTrattamentoTipoAttoRepository civDisposizioniAnticipateTrattamentoTipoAttoRepository) {
        this.civDisposizioniAnticipateTrattamentoTipoAttoRepository = civDisposizioniAnticipateTrattamentoTipoAttoRepository
    }

    List<CivDisposizioniAnticipateTrattamentoTipoAtto> listAll(Sort s){
        return civDisposizioniAnticipateTrattamentoTipoAttoRepository.findAll(s)
    }


}
