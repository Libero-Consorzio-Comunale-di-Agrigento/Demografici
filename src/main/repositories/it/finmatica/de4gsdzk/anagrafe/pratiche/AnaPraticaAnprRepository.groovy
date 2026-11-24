package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaPraticaAnprRepository extends JpaRepository<AnaPraticaAnpr, Long> {

    @Query(value = """SELECT p FROM AnaPraticaAnpr p
                        LEFT OUTER JOIN FETCH p.allegati
                        WHERE (:tipoPratica IS NULL OR p.tipoPratica = :tipoPratica)
                        AND (CAST(p.dichiarante AS string) LIKE :filtro
                            OR UPPER(p.dichiarante) LIKE UPPER(:filtro))""",
            countQuery = """SELECT count(p) FROM AnaPraticaAnpr p
                            WHERE (:tipoPratica IS NULL OR p.tipoPratica = :tipoPratica)
                            AND (CAST(p.dichiarante AS string) LIKE :filtro
                                OR UPPER(p.dichiarante) LIKE UPPER(:filtro))""")
    Page<AnaPraticaAnpr> findAllByTipoPraticaAndFiltroLike(@Param("tipoPratica") ETipoPratica tipoPratica,
                                                           @Param("filtro") String filtro,
                                                           Pageable p)

    @Modifying
    @Query(value = """UPDATE anpads
                        SET anagrafe_ads = :anagrafe,
                            tipo_evento_ads = :tipoEvento,
                            anno_pratica_ads = :annoPratica,
                            pratica_ads = :pratica
                        WHERE tipo_scheda_anpr = 'Richiesta'
                        AND id_scheda_anpr = :id""", nativeQuery = true)
    void updateAnpads(@Param("id") Long id,
                      @Param("anagrafe") String anagrafe,
                      @Param("tipoEvento") String tipoEvento,
                      @Param("annoPratica") Integer annoPratica,
                      @Param("pratica") Integer pratica)

}