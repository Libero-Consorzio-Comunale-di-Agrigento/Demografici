package it.finmatica.de4gsdzk.archivi

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.archivi.ArcComuneStorico
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface ArcComuneStoricoRepository extends JpaRepository<ArcComuneStorico, String> {

    ArcComuneStorico findByCodiceComuneAndCodiceProvincia(Integer codiceComune, Integer codiceProvincia)

    @Query(value = """SELECT c FROM ArcComuneStorico c 
                       WHERE COALESCE(c.dataInizioValidita,:d) <= :d AND COALESCE(c.dataFineValidita,:d) >= :d 
                         AND UPPER(c.descrizioneComune) LIKE UPPER(:filtro) """,
            countQuery = """SELECT count(c) FROM ArcComuneStorico c 
                             WHERE COALESCE(c.dataInizioValidita,:d) <= :d AND COALESCE(c.dataFineValidita,:d) >= :d
                               AND UPPER(c.descrizioneComune) LIKE UPPER(:filtro) """)
    Page<ArcComuneStorico> findAllByDescrizioneComuneLikeIgnoreCaseAndDataRif(@Param("filtro") String filtro,
                                                                              @Param("d") Date d,
                                                                              Pageable pageable)

    @Query(value = """SELECT c FROM ArcComuneStorico c 
                       WHERE COALESCE(c.dataInizioValidita,:d) <= :d AND COALESCE(c.dataFineValidita,:d) >= :d 
                         AND UPPER(c.descrizioneComune) LIKE UPPER(:filtro) 
                         AND c.id NOT IN (:ids) """,
            countQuery = """SELECT count(c) FROM ArcComuneStorico c 
                             WHERE COALESCE(c.dataInizioValidita,:d) <= :d AND COALESCE(c.dataFineValidita,:d) >= :d
                               AND UPPER(c.descrizioneComune) LIKE UPPER(:filtro) 
                               AND c.id NOT IN (:ids) """)
    Page<ArcComuneStorico> findAllByIdNotInAndDescrizioneComuneLikeIgnoreCaseAndDataRif(@Param("ids") List<String> ids,
                                                                                        @Param("filtro") String filtro,
                                                                                        @Param("d") Date d,
                                                                                        Pageable pageable)

    @Query(value = """SELECT c FROM ArcComuneStorico c 
                       WHERE COALESCE(c.dataInizioValidita,:d) <= :d AND COALESCE(c.dataFineValidita,:d) >= :d
                         AND c.id NOT IN (:ids) """,
            countQuery = """SELECT count(c) FROM ArcComuneStorico c 
                             WHERE COALESCE(c.dataInizioValidita,:d) <= :d AND COALESCE(c.dataFineValidita,:d) >= :d
                               AND c.id NOT IN (:ids) """)
    Page<ArcComuneStorico> findAllByIdNotInAndDataRif(@Param("ids") List<String> ids,
                                                      @Param("d") Date d,
                                                      Pageable pageable)

    @Query(value = """SELECT c FROM ArcComuneStorico c 
                       WHERE COALESCE(c.dataInizioValidita,:d) <= :d AND COALESCE(c.dataFineValidita,:d) >= :d""",
            countQuery = """SELECT count(c) FROM ArcComuneStorico c 
                             WHERE COALESCE(c.dataInizioValidita,:d) <= :d AND COALESCE(c.dataFineValidita,:d) >= :d """)
    Page<ArcComuneStorico> findAllByDataRif(@Param("d") Date d,
                                            Pageable pageable)

}