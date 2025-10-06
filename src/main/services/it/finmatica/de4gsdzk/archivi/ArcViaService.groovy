package it.finmatica.de4gsdzk.archivi

import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class ArcViaService {

    private final ArcViaRepository arcViaRepository

    ArcViaService(ArcViaRepository arcViaRepository) {
        this.arcViaRepository = arcViaRepository
    }

    Page<ArcVia> listAllByDenominazione(String filtro, PageRequest p) {
        return arcViaRepository.findAllByDenominazioneLikeIgnoreCase(filtro ? SqlUtils.beginsAndEndsLike(filtro) : '%', p)
    }


}
