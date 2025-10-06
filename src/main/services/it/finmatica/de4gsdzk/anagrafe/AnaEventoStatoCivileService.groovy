package it.finmatica.de4gsdzk.anagrafe


import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaEventoStatoCivileService {

    private final AnaEventoStatoCivileRepository anaEventoStatoCivileRepository

    AnaEventoStatoCivileService(AnaEventoStatoCivileRepository anaEventoStatoCivileRepository) {
        this.anaEventoStatoCivileRepository = anaEventoStatoCivileRepository
    }

    Page<AnaEventoStatoCivile> findAllByAnagrafe(AnaAnagrafe anagrafe, Pageable p) {
        return anaEventoStatoCivileRepository.findAllByAnagrafe(anagrafe, p)
    }

    boolean existsByAnagrafe(AnaAnagrafe anagrafe) {
        return anaEventoStatoCivileRepository.countByAnagrafe(anagrafe) > 0
    }

}
