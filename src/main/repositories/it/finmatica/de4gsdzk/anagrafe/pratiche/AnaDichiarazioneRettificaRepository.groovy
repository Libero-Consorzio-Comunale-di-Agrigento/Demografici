package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaDichiarazioneRettificaRepository extends JpaRepository<AnaDichiarazioneRettifica, String> {


    @Query("""
        SELECT d
        FROM AnaDichiarazioneRettifica d
        LEFT JOIN FETCH d.soggettiRettifica s
        LEFT JOIN FETCH s.anagrafe a
        LEFT JOIN FETCH a.stato
        LEFT JOIN FETCH a.rapportoParentela
        LEFT JOIN FETCH a.famiglia f
        LEFT JOIN FETCH f.tipoConvivenza
        LEFT JOIN FETCH f.intestatarioConvivenza
        LEFT JOIN FETCH d.indirizzo.via
        WHERE d.pratica = :pratica
    """)
    AnaDichiarazioneRettifica findByPratica(@Param("pratica") AnaPratica pratica)

}