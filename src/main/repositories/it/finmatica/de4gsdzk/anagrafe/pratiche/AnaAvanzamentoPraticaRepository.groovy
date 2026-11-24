package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaAvanzamentoPraticaRepository extends JpaRepository<AnaAvanzamentoPratica, Integer> {

    @Query("""
        SELECT a
        FROM AnaAvanzamentoPratica a
        LEFT JOIN FETCH a.eventoPratica
        WHERE a.id = :id
    """)
    AnaAvanzamentoPratica findById(@Param("id") Integer id)

}