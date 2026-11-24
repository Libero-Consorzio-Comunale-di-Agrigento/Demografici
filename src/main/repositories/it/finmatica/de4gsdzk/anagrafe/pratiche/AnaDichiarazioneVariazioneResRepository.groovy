package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaDichiarazioneVariazioneResRepository extends JpaRepository<AnaDichiarazioneVariazioneRes, String> {


    @Query("""
        SELECT d
        FROM AnaDichiarazioneVariazioneRes d
        LEFT JOIN FETCH d.soggettiVariazioneRes s
        LEFT JOIN FETCH s.anagrafe a
        LEFT JOIN FETCH a.stato
        LEFT JOIN FETCH a.famiglia
        LEFT JOIN FETCH a.rapportoParentela
        LEFT JOIN FETCH d.indirizzo.via
        LEFT JOIN FETCH d.tipoConvivenza
        LEFT JOIN FETCH d.famigliaDest
        LEFT JOIN FETCH d.famigliaProv
        LEFT JOIN FETCH d.intestatarioConvivenza
        WHERE d.pratica = :pratica
    """)
    AnaDichiarazioneVariazioneRes findByPratica(@Param("pratica") AnaPratica pratica)

}