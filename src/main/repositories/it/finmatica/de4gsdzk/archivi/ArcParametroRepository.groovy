package it.finmatica.de4gsdzk.archivi

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.utils.EGruppo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface ArcParametroRepository extends JpaRepository<ArcParametro, String> {

    ArcParametro findById(String id)

    @Query("""SELECT a FROM ArcParametro a 
                      WHERE (a.gruppo IS NULL OR a.gruppo IN (:gruppi)) 
                        AND a.flagVisibile = java.lang.Boolean.TRUE 
                        AND (UPPER(a.descrizione) LIKE UPPER(:filtro) OR UPPER(a.id) LIKE UPPER(:filtro) OR UPPER(a.note) LIKE UPPER(:filtro)) """)
    Page<ArcParametro> findAllByGruppoInAndDescrizioneLike(@Param("gruppi") List<EGruppo> gruppi, @Param("filtro") String filtro, Pageable pageable)

    @Query("""SELECT a FROM ArcParametro a 
                      WHERE (a.gruppo IS NULL OR a.gruppo IN (:gruppi)) 
                        AND a.flagVisibile = java.lang.Boolean.TRUE """)
    Page<ArcParametro> findAllByGruppoIn(@Param("gruppi") List<EGruppo> gruppi, Pageable pageable)

    List<ArcParametro> findAllByIdInOrderById(List<String> ids)

    List<ArcParametro> findAllByIdLike(@Param("parametro") String parametro)

}