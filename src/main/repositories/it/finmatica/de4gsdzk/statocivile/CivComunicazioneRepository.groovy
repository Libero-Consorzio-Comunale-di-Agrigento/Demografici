package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoComunicazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivComunicazioneRepository extends JpaRepository<CivComunicazione, Integer>, CivComunicazioneCustomRepository {

    @Query("SELECT c FROM CivComunicazione c WHERE c.id = :id ")
    CivComunicazione findById(@Param("id") Integer id)

    @Query("""SELECT c FROM CivComunicazioneAtto ca, CivComunicazione c 
               WHERE ca.comunicazione.id = c.id AND ca.tipoAtto = :tipoAtto
               AND (:filtro IS NULL OR c.descrizione LIKE :filtro) 
               ORDER BY c.id """)
    Page<CivComunicazione> findAllByTipoAtto(@Param("tipoAtto") Integer tipoAtto, @Param("filtro") String filtro, Pageable pageable)

    @Query("""SELECT DISTINCT(c) FROM CivComunicazioneFormula cf, CivComunicazione c 
            WHERE cf.comunicazione.id = c.id
            AND (:filtro IS NULL OR c.descrizione LIKE :filtro) 
            ORDER BY c.id """)
    Page<CivComunicazione> findAllInFormule(@Param("filtro") String filtro, Pageable pageable)

    @Query("""SELECT DISTINCT(c) FROM CivArchivioComunicazione arc, CivComunicazione c
               WHERE arc.tipoAttoComunicazione = :tipoAttoComunicazione
                 AND arc.comunicazione.id = c.id
                 AND arc.stampaEseguita = :stampaEseguita)
               ORDER BY c.descrizione """)
    List<CivComunicazione> findAllByTipoAttoComunicazioneAndStampaEseguita(@Param("tipoAttoComunicazione") Integer tipoAttoComunicazione, @Param("stampaEseguita") Boolean stampaEseguita)

    @Query("""SELECT c FROM CivComunicazione c 
                WHERE c.tipoComunicazione = :tipoComunicazione
                AND (:escludiId IS NULL OR c.id <> :escludiId)
                AND (:escludiTipoAtto IS NULL OR c.id NOT IN (
                    SELECT comunicazione.id FROM CivComunicazioneAtto WHERE tipoAtto=:escludiTipoAtto
                ))
                AND (:escludiFormula IS NULL OR c.id NOT IN (
                    SELECT comunicazione.id FROM CivComunicazioneFormula WHERE formula=:escludiFormula
                ))
                AND (:filtro IS NULL OR c.descrizione LIKE :filtro)
                ORDER BY c.id""")
    Page<CivComunicazione> findAllByTipoComunicazione(
            @Param("tipoComunicazione") ETipoComunicazione tipoComunicazione,
            @Param("escludiId") Integer id,
            @Param("escludiTipoAtto") Integer escludiTipoAtto,
            @Param("escludiFormula") CivFormulaAnnotazione formula,
            @Param("filtro") String filtro,
            Pageable pageable)

    long countById(Integer idComunicazione)

}