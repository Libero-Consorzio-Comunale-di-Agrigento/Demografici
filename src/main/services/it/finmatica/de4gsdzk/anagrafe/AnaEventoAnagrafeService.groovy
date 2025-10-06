package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaEventoAnagrafeService {

    private final AnaEventoAnagrafeRepository anaEventoAnagrafeRepository

    AnaEventoAnagrafeService(AnaEventoAnagrafeRepository anaEventoAnagrafeRepository) {
        this.anaEventoAnagrafeRepository = anaEventoAnagrafeRepository
    }

    Page<AnaEventoAnagrafe> findAllByAnagrafe(AnaAnagrafe anagrafe, Pageable pageable) {
        return anaEventoAnagrafeRepository.findAllByAnagrafe(anagrafe, pageable)
    }

    boolean existsByAnagrafe(AnaAnagrafe anagrafe) {
        return anaEventoAnagrafeRepository.countByAnagrafe(anagrafe) > 0
    }

}
