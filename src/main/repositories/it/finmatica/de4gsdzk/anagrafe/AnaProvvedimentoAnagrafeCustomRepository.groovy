package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable

interface AnaProvvedimentoAnagrafeCustomRepository {
    Page<AnaProvvedimentoAnagrafe> findAllByAnagrafe(AnaAnagrafe anagrafe, boolean includiPrivati, Pageable pageable)

    long countByAnagrafe(AnaAnagrafe anagrafe, boolean includiPrivati)
}