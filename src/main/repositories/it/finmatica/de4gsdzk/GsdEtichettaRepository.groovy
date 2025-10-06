package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.GsdEtichetta
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface GsdEtichettaRepository extends JpaRepository<GsdEtichetta, String> {

    GsdEtichetta findById(String id)

    Page<GsdEtichetta> findAllByIdLikeIgnoreCase(String filtro, Pageable pageable)

    List<GsdEtichetta> findAllByIdIn(List<String> ids)

}