package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.LogDocArea
import it.finmatica.de4gsdzk.LogProjection
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface LogDocAreaRepository extends JpaRepository<LogDocArea, Long> {

    @Query("""
        SELECT new it.finmatica.de4gsdzk.LogProjection(id, dataOra, operazione, note, noteVis) 
        FROM LogDocArea l """)
    Page<LogProjection> findAllNoClob(Pageable p)

    @Query("""
        SELECT new it.finmatica.de4gsdzk.LogProjection(id, dataOra, operazione, note, noteVis) 
        FROM LogDocArea l 
        WHERE UPPER(l.note) LIKE :filtro OR UPPER(l.operazione) LIKE :filtro """)
    Page<LogProjection> findAllNoClobFilter(@Param("filtro") String filtro, Pageable p)

}
