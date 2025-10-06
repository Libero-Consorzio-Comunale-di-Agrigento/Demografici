package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.CompetenzaService
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaProvvedimentoAnagrafeService {

    private final AnaProvvedimentoAnagrafeRepository anaProvvedimentoAnagrafeRepository
    private final CompetenzaService competenzaService

    AnaProvvedimentoAnagrafeService(AnaProvvedimentoAnagrafeRepository anaProvvedimentoAnagrafeRepository,
                                    CompetenzaService competenzaService) {
        this.anaProvvedimentoAnagrafeRepository = anaProvvedimentoAnagrafeRepository
        this.competenzaService = competenzaService
    }

    Page<AnaProvvedimentoAnagrafe> findAllByAnagrafe(AnaAnagrafe anagrafe, Pageable pageable) {
        boolean includiPrivati = competenzaService.isAnaSuperUser()
        return anaProvvedimentoAnagrafeRepository.findAllByAnagrafe(anagrafe, includiPrivati, pageable)
    }

    boolean existsByAnagrafe(AnaAnagrafe anagrafe) {
        boolean includiPrivati = competenzaService.isAnaSuperUser()
        return anaProvvedimentoAnagrafeRepository.countByAnagrafe(anagrafe, includiPrivati) > 0
    }

}
