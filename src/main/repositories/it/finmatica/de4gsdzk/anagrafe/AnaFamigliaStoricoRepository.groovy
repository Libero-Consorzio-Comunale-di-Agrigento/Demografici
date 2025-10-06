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
interface AnaFamigliaStoricoRepository extends JpaRepository<AnaFamigliaStorico, String>  {

    @Query(value = """SELECT o FROM AnaFamigliaStorico o
                        LEFT JOIN FETCH o.indirizzoResidente.via
                        LEFT JOIN FETCH o.capoFamiglia
                        LEFT JOIN FETCH o.intestatarioConvivenza
                       WHERE o.fascia in (it.finmatica.de4gsdzk.anagrafe.EFascia.ISCRITTO_APR, it.finmatica.de4gsdzk.anagrafe.EFascia.CANCELLATO_APR)
                         AND (:via IS NULL OR o.indirizzoResidente.via = :via)  
                         AND (:numeroCivico IS NULL OR o.indirizzoResidente.numeroCivico = :numeroCivico)
                         AND (:suffisso IS NULL OR o.indirizzoResidente.suffisso = :suffisso)
                         AND (:interno IS NULL OR o.indirizzoResidente.interno = :interno)
                         AND (:subInterno IS NULL OR o.indirizzoResidente.subInterno = :subInterno)
                         AND (:scala IS NULL OR o.indirizzoResidente.scala = :scala)
                         AND (:piano IS NULL OR o.indirizzoResidente.piano = :piano)
                         AND (:convivenza IS NULL OR COALESCE(o.convivenza, java.lang.Boolean.FALSE) = :convivenza)
                         AND (:fascia IS NULL OR o.fascia = :fascia)
                         AND :data between o.dataInizioResidenza and o.dataFineResidenza
                         AND :data between o.dataInizioFamiglia and o.dataFineFamiglia
                       ORDER BY 
                         o.indirizzoResidente.via.denominazioneOrdinamento,
                         o.indirizzoResidente.numeroCivico,
                         CASE WHEN o.indirizzoResidente.suffisso IS NULL THEN 0 ELSE 1 END,
                         o.indirizzoResidente.suffisso,
                         CASE WHEN o.indirizzoResidente.interno IS NULL THEN 0 ELSE 1 END,
                         o.indirizzoResidente.interno,
                         CASE WHEN o.indirizzoResidente.subInterno IS NULL THEN 0 ELSE 1 END,
                         o.indirizzoResidente.subInterno,
                         CASE WHEN o.indirizzoResidente.scala IS NULL THEN 0 ELSE 1 END,
                         o.indirizzoResidente.scala,
                         CASE WHEN o.indirizzoResidente.piano IS NULL THEN 0 ELSE 1 END,
                         o.indirizzoResidente.piano,
                         o.capoFamiglia.fascia,
                         o.capoFamiglia.dataNascita,
                         o.capoFamiglia.cognome,
                         o.capoFamiglia.nome""",
            countQuery = """SELECT count(o) FROM AnaFamigliaStorico o
                             LEFT JOIN o.indirizzoResidente.via
                             LEFT JOIN o.capoFamiglia
                             LEFT JOIN o.intestatarioConvivenza
                            WHERE o.fascia in (it.finmatica.de4gsdzk.anagrafe.EFascia.ISCRITTO_APR, it.finmatica.de4gsdzk.anagrafe.EFascia.CANCELLATO_APR)
                              AND (:via IS NULL OR o.indirizzoResidente.via = :via)  
                              AND (:numeroCivico IS NULL OR o.indirizzoResidente.numeroCivico = :numeroCivico)
                              AND (:suffisso IS NULL OR o.indirizzoResidente.suffisso = :suffisso)
                              AND (:interno IS NULL OR o.indirizzoResidente.interno = :interno)
                              AND (:subInterno IS NULL OR o.indirizzoResidente.subInterno = :subInterno)
                              AND (:scala IS NULL OR o.indirizzoResidente.scala = :scala)
                              AND (:piano IS NULL OR o.indirizzoResidente.piano = :piano)
                              AND (:convivenza IS NULL OR COALESCE(o.convivenza, java.lang.Boolean.FALSE) = :convivenza)
                              AND (:fascia IS NULL OR o.fascia = :fascia)
                              AND :data between o.dataInizioResidenza and o.dataFineResidenza
                              AND :data between o.dataInizioFamiglia and o.dataFineFamiglia""")
    Page<AnaFamigliaStorico> findAllByRicercaFamiglia(
            @Param("via") ArcVia via,
            @Param("numeroCivico") Long numeroCivico,
            @Param("suffisso") String suffisso,
            @Param("interno") Long interno,
            @Param("subInterno") String subInterno,
            @Param("scala") String scala,
            @Param("piano") String piano,
            @Param("convivenza") Boolean convivenza,
            @Param("fascia") EFascia fascia,
            @Param("data") Date data,
            Pageable pageable)

}
