package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoRichiestaRepository
import it.finmatica.de4gsdzk.utils.ETipoAtto
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivCategoriaTipoRichiestaService {

    private final CivCategoriaTipoRichiestaRepository civCategoriaTipoRichiestaRepository

    CivCategoriaTipoRichiestaService(CivCategoriaTipoRichiestaRepository civCategoriaTipoRichiestaRepository) {
        this.civCategoriaTipoRichiestaRepository = civCategoriaTipoRichiestaRepository
    }

    List<CivCategoriaTipoRichiesta> listAllByCivCategoriaTipoAtto(CivCategoriaTipoAtto civCategoriaTipoAtto) {
        if (civCategoriaTipoAtto == null) {
            return []
        }
        return civCategoriaTipoRichiestaRepository.findAllByTipoAttoAndSiglaCategoria(civCategoriaTipoAtto.tipoAtto, civCategoriaTipoAtto.codice)
    }

    List<CivCategoriaTipoRichiesta> listAllByTipoAtto(ETipoAtto tipoAtto) {
        return civCategoriaTipoRichiestaRepository.findAllByTipoAtto(tipoAtto.valore)
    }
}
