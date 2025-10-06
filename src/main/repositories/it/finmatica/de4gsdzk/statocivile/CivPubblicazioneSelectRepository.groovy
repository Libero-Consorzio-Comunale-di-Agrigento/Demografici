package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivPubblicazioneSelect
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivPubblicazioneSelectRepository extends JpaRepository<CivPubblicazioneSelect, Long> {

    Page<CivPubblicazioneSelect> findAllByCognome1LikeIgnoreCaseOrNome1LikeIgnoreCaseOrCognome2LikeIgnoreCaseOrNome2LikeIgnoreCase(String filtroCognome1, String filtroNome1,
                                                                                                                                   String filtroCognome2, String filtroNome2,
                                                                                                                                   Pageable pageable)
}