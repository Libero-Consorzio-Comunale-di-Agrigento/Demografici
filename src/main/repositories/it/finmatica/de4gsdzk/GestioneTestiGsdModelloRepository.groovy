package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.GestioneTestiGsdProjection
import it.finmatica.de4gsdzk.utils.EAmbito
import it.finmatica.de4gsdzk.utils.EGruppo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface GestioneTestiGsdModelloRepository extends JpaRepository<GestioneTestiGsdModello, Long> {

    @Query("SELECT count(*) FROM GestioneTestiGsdModello g WHERE g.gruppo = :gruppo AND g.ambito = :ambito ")
    long countByGruppoAndAmbito(@Param("gruppo") EGruppo gruppo, @Param("ambito") EAmbito ambito)

    @Query("SELECT g FROM GestioneTestiGsdModello g LEFT JOIN FETCH g.tipoModello WHERE g.id = :id ")
    GestioneTestiGsdModello findById(@Param("id") Long id)

    @Query("SELECT g FROM GestioneTestiGsdModello g JOIN FETCH g.tipoModello WHERE g.ambito = it.finmatica.de4gsdzk.utils.EAmbito.ET ")
    GestioneTestiGsdModello findByAmbitoEtichetta()

    @Query("SELECT new it.finmatica.de4gsdzk.GestioneTestiGsdProjection(id, codice, descrizione, gruppo, ambito) FROM GestioneTestiGsdModello g WHERE g.gruppo = :gruppo AND g.ambito = :ambito ")
    Page<GestioneTestiGsdProjection> findByGruppoAndAmbito(@Param("gruppo") EGruppo gruppo, @Param("ambito") EAmbito ambito, Pageable p)
}