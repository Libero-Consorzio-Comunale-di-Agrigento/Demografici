package it.finmatica.de4gsdzk


import it.finmatica.de4gsdzk.LogGestioneTesti
import it.finmatica.de4gsdzk.LogProjection
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface LogGestioneTestiRepository extends JpaRepository<LogGestioneTesti, Long> {

    @Query("""
        SELECT new it.finmatica.de4gsdzk.LogProjection(id, dataOra, operazione, note, noteVis) 
        FROM LogGestioneTesti l """)
    Page<LogProjection> findAllNoClob(Pageable p)

    @Query("""
        SELECT new it.finmatica.de4gsdzk.LogProjection(id, dataOra, operazione, note, noteVis) 
        FROM LogGestioneTesti l 
        WHERE UPPER(l.note) LIKE :filtro OR UPPER(l.operazione) LIKE :filtro OR UPPER(l.noteVis) LIKE :filtro """)
    Page<LogProjection> findAllNoClobFilter(@Param("filtro") String filtro, Pageable p)

}
