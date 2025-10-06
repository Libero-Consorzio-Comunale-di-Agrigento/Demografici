package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaEventoAnagrafeCustomRepository {
    Page<AnaEventoAnagrafe> findAllByAnagrafe(AnaAnagrafe anagrafe,
                                              Pageable pageable)

    long countByAnagrafe(AnaAnagrafe anagrafe)
}