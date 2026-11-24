package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaDichiarazioneIscrizioneResRepository extends JpaRepository<AnaDichiarazioneIscrizioneRes, String> {


    @Query("""
        SELECT d
        FROM AnaDichiarazioneIscrizioneRes d
        LEFT JOIN FETCH d.soggettiIscrizioneRes s
        LEFT JOIN FETCH s.statoRipristino
        LEFT JOIN FETCH s.anagrafe a
        LEFT JOIN FETCH a.stato
        LEFT JOIN FETCH a.famiglia
        LEFT JOIN FETCH a.rapportoParentela
        LEFT JOIN FETCH s.rapportoParentela
        LEFT JOIN FETCH d.indirizzo.via
        LEFT JOIN FETCH d.provvedimento
        LEFT JOIN FETCH d.richiesta
        LEFT JOIN FETCH d.tipoConvivenza
        LEFT JOIN FETCH d.famigliaDest
        LEFT JOIN FETCH d.famigliaProv
        LEFT JOIN FETCH d.intestatarioConvivenza
        WHERE d.pratica = :pratica
    """)
    AnaDichiarazioneIscrizioneRes findByPratica(@Param("pratica") AnaPratica pratica)


    @Modifying
    @Query("UPDATE AnaDichiarazioneIscrizioneRes d SET d.codFamigliaProv = :codFamigliaProv WHERE d.id = :id")
    void updateCodiceFamiglia(@Param("id") Integer id, @Param("codFamigliaProv") Long codFamigliaProv)

}