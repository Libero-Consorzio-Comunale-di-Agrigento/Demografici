package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaPraticaRepository extends JpaRepository<AnaPratica, String> {

    @Query("""
        SELECT p
        FROM AnaPratica p
        LEFT JOIN FETCH p.iniziativa
        LEFT JOIN FETCH p.occupazioneImmobile
        LEFT JOIN FETCH p.statoPratica
        WHERE p.id = :id
    """)
    AnaPratica findById(@Param("id") Long id)

    @Query("""
        SELECT p
        FROM AnaPratica p
        LEFT JOIN FETCH p.avanzamentiPratica a
        LEFT JOIN FETCH a.eventoPratica
        WHERE p.id = :id
    """)
    AnaPratica findAvanzamentiById(@Param("id") Long id)

}