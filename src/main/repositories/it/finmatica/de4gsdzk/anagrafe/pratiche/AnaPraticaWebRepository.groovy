package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaPraticaWebRepository extends JpaRepository<AnaPraticaWeb, Long> {

    @Query(value = """SELECT p FROM AnaPraticaWeb p
                        LEFT OUTER JOIN FETCH p.allegati
                        WHERE (:tipoPratica IS NULL OR p.tipoPratica = :tipoPratica)
                        AND (CAST(p.dichiarante AS string) LIKE :filtro
                             OR UPPER(p.dichiarante) LIKE UPPER(:filtro))""",
            countQuery = """SELECT count(p) FROM AnaPraticaWeb p
                            WHERE (:tipoPratica IS NULL OR p.tipoPratica = :tipoPratica)
                            AND (CAST(p.dichiarante AS string) LIKE :filtro
                                OR UPPER(p.dichiarante) LIKE UPPER(:filtro))""")
    Page<AnaPraticaWeb> findAllByTipoPraticaAndFiltroLike(@Param("tipoPratica") ETipoPratica tipoPratica,
                                                          @Param("filtro") String filtro,
                                                          Pageable p)

}