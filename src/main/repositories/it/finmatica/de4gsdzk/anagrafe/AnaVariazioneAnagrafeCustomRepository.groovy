package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable

interface AnaVariazioneAnagrafeCustomRepository {
    Page<AnaVariazioneAnagrafe> findAllByAnagrafe(AnaAnagrafe anagrafe, boolean includiPrivati, Pageable pageable)

    long countByAnagrafe(AnaAnagrafe anagrafe, boolean includiPrivati)
}