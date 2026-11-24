package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.archivi.ArcVia
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaIndirizzoStradarioRepository extends JpaRepository<AnaIndirizzoStradario, String> {

    @Query(value = """SELECT o FROM AnaIndirizzoStradario o
                LEFT JOIN FETCH o.indirizzo.indirizzo.via
                LEFT JOIN FETCH o.famiglia f
                LEFT JOIN FETCH f.tipoConvivenza
                LEFT JOIN FETCH f.intestatarioConvivenza
                WHERE (:via IS NULL OR o.indirizzo.indirizzo.via = :via)
                AND (:numeroCivico IS NULL OR o.indirizzo.indirizzo.numeroCivico = :numeroCivico)
                AND (:suffisso IS NULL OR o.indirizzo.indirizzo.suffisso = :suffisso)
                AND (:interno IS NULL OR o.indirizzo.indirizzo.interno = :interno)
                AND (:subInterno IS NULL OR o.indirizzo.indirizzo.subInterno = :subInterno)
                AND (:scala IS NULL OR o.indirizzo.indirizzo.scala = :scala)
                AND (:piano IS NULL OR o.indirizzo.indirizzo.piano = :piano)
                AND (:tipoFamiglia IS NULL OR o.tipoFamiglia = :tipoFamiglia)""",
            countQuery = """SELECT count(o) FROM AnaIndirizzoStradario o
                WHERE (:via IS NULL OR o.indirizzo.indirizzo.via = :via)
                AND (:numeroCivico IS NULL OR o.indirizzo.indirizzo.numeroCivico = :numeroCivico)
                AND (:suffisso IS NULL OR o.indirizzo.indirizzo.suffisso = :suffisso)
                AND (:interno IS NULL OR o.indirizzo.indirizzo.interno = :interno)
                AND (:subInterno IS NULL OR o.indirizzo.indirizzo.subInterno = :subInterno)
                AND (:scala IS NULL OR o.indirizzo.indirizzo.scala = :scala)
                AND (:piano IS NULL OR o.indirizzo.indirizzo.piano = :piano)
                AND (:tipoFamiglia IS NULL OR o.tipoFamiglia = :tipoFamiglia)""")
    Page<AnaIndirizzoStradario> findAllByRicercaFamiglia(
            @Param("via") ArcVia via,
            @Param("numeroCivico") Long numeroCivico,
            @Param("suffisso") String suffisso,
            @Param("interno") Long interno,
            @Param("subInterno") String subInterno,
            @Param("scala") String scala,
            @Param("piano") String piano,
            @Param("tipoFamiglia") ETipoFamiglia tipoFamiglia,
            Pageable pageable)

}