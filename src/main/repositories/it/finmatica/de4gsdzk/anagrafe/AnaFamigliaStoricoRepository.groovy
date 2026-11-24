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
                        LEFT JOIN FETCH o.indirizzoResidente.indirizzo.via
                        LEFT JOIN FETCH o.capoFamiglia
                        LEFT JOIN FETCH o.intestatarioConvivenza
                       WHERE o.fascia in (it.finmatica.de4gsdzk.anagrafe.EFascia.ISCRITTO_APR, it.finmatica.de4gsdzk.anagrafe.EFascia.CANCELLATO_APR)
                         AND (:via IS NULL OR o.indirizzoResidente.indirizzo.via = :via)  
                         AND (:numeroCivico IS NULL OR o.indirizzoResidente.indirizzo.numeroCivico = :numeroCivico)
                         AND (:suffisso IS NULL OR o.indirizzoResidente.indirizzo.suffisso = :suffisso)
                         AND (:interno IS NULL OR o.indirizzoResidente.indirizzo.interno = :interno)
                         AND (:subInterno IS NULL OR o.indirizzoResidente.indirizzo.subInterno = :subInterno)
                         AND (:scala IS NULL OR o.indirizzoResidente.indirizzo.scala = :scala)
                         AND (:piano IS NULL OR o.indirizzoResidente.indirizzo.piano = :piano)
                         AND (:convivenza IS NULL OR COALESCE(o.convivenza, java.lang.Boolean.FALSE) = :convivenza)
                         AND (:fascia IS NULL OR o.fascia = :fascia)
                         AND :data between o.dataInizioResidenza and o.dataFineResidenza
                         AND :data between o.dataInizioFamiglia and o.dataFineFamiglia
                       ORDER BY 
                         o.indirizzoResidente.indirizzo.via.denominazioneOrdinamento,
                         o.indirizzoResidente.indirizzo.numeroCivico,
                         CASE WHEN o.indirizzoResidente.indirizzo.suffisso IS NULL THEN 0 ELSE 1 END,
                         o.indirizzoResidente.indirizzo.suffisso,
                         CASE WHEN o.indirizzoResidente.indirizzo.interno IS NULL THEN 0 ELSE 1 END,
                         o.indirizzoResidente.indirizzo.interno,
                         CASE WHEN o.indirizzoResidente.indirizzo.subInterno IS NULL THEN 0 ELSE 1 END,
                         o.indirizzoResidente.indirizzo.subInterno,
                         CASE WHEN o.indirizzoResidente.indirizzo.scala IS NULL THEN 0 ELSE 1 END,
                         o.indirizzoResidente.indirizzo.scala,
                         CASE WHEN o.indirizzoResidente.indirizzo.piano IS NULL THEN 0 ELSE 1 END,
                         o.indirizzoResidente.indirizzo.piano,
                         o.capoFamiglia.fascia,
                         o.capoFamiglia.dataNascita,
                         o.capoFamiglia.cognome,
                         o.capoFamiglia.nome""",
            countQuery = """SELECT count(o) FROM AnaFamigliaStorico o
                             LEFT JOIN o.indirizzoResidente.indirizzo.via
                             LEFT JOIN o.capoFamiglia
                             LEFT JOIN o.intestatarioConvivenza
                            WHERE o.fascia in (it.finmatica.de4gsdzk.anagrafe.EFascia.ISCRITTO_APR, it.finmatica.de4gsdzk.anagrafe.EFascia.CANCELLATO_APR)
                              AND (:via IS NULL OR o.indirizzoResidente.indirizzo.via = :via)  
                              AND (:numeroCivico IS NULL OR o.indirizzoResidente.indirizzo.numeroCivico = :numeroCivico)
                              AND (:suffisso IS NULL OR o.indirizzoResidente.indirizzo.suffisso = :suffisso)
                              AND (:interno IS NULL OR o.indirizzoResidente.indirizzo.interno = :interno)
                              AND (:subInterno IS NULL OR o.indirizzoResidente.indirizzo.subInterno = :subInterno)
                              AND (:scala IS NULL OR o.indirizzoResidente.indirizzo.scala = :scala)
                              AND (:piano IS NULL OR o.indirizzoResidente.indirizzo.piano = :piano)
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
