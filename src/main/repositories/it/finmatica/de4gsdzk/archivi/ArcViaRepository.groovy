package it.finmatica.de4gsdzk.archivi

import groovy.transform.CompileStatic
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface ArcViaRepository extends JpaRepository<ArcVia, String> {

    @Query(""" SELECT o FROM ArcVia o
                WHERE UPPER(o.denominazione) like UPPER(:filtro)
                  OR UPPER(o.denominazioneRicerca) like UPPER(:filtro)""")
    Page<ArcVia> findAllByDenominazioneLikeIgnoreCase(@Param("filtro") String filtro, Pageable pageable)

}