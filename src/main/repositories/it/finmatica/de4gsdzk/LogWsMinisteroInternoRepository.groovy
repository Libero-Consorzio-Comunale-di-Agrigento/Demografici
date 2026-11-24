package it.finmatica.de4gsdzk


import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface LogWsMinisteroInternoRepository extends JpaRepository<LogWsMinisteroInterno, Long> {

    @Query("""
        SELECT new it.finmatica.de4gsdzk.LogProjection(id, dataOra, operazione, note, noteVis) 
        FROM LogWsMinisteroInterno l """)
    Page<LogProjection> findAllNoClob(Pageable p)

    @Query("""
        SELECT new it.finmatica.de4gsdzk.LogProjection(id, dataOra, operazione, note, noteVis) 
        FROM LogWsMinisteroInterno l 
        WHERE UPPER(l.note) LIKE :filtro OR UPPER(l.operazione) LIKE :filtro """)
    Page<LogProjection> findAllNoClobFilter(@Param("filtro") String filtro, Pageable p)

}
