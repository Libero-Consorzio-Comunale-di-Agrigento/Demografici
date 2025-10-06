package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.CompetenzaService
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaVariazioneAnagrafeService {

    private final AnaVariazioneAnagrafeRepository anaVariazioneAnagrafeRepository
    private final CompetenzaService competenzaService

    AnaVariazioneAnagrafeService(AnaVariazioneAnagrafeRepository anaVariazioneAnagrafeRepository,
                                 CompetenzaService competenzaService) {
        this.anaVariazioneAnagrafeRepository = anaVariazioneAnagrafeRepository
        this.competenzaService = competenzaService
    }

    Page<AnaVariazioneAnagrafe> findAllByAnagrafe(AnaAnagrafe anagrafe, Pageable pageable) {
        boolean includiPrivati = competenzaService.isAnaSuperUser()
        return anaVariazioneAnagrafeRepository.findAllByAnagrafe(anagrafe, includiPrivati, pageable)
    }

    boolean existsByAnagrafe(AnaAnagrafe anagrafe) {
        boolean includiPrivati = competenzaService.isAnaSuperUser()
        return anaVariazioneAnagrafeRepository.countByAnagrafe(anagrafe, includiPrivati) > 0
    }

}
