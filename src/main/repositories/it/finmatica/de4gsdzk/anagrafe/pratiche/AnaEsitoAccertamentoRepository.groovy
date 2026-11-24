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
interface AnaEsitoAccertamentoRepository extends JpaRepository<AnaEsitoAccertamento, Long> {

    @Query(value = """SELECT e FROM AnaEsitoAccertamento e
                        LEFT OUTER JOIN FETCH e.avanzamento a
                        LEFT OUTER JOIN FETCH a.pratica p
                        LEFT OUTER JOIN FETCH p.allegati
                        WHERE (:tipoPratica IS NULL OR e.tipoPratica = :tipoPratica)""",
            countQuery = """SELECT count(e) FROM AnaEsitoAccertamento e
                            WHERE (:tipoPratica IS NULL OR e.tipoPratica = :tipoPratica)""")
    Page<AnaEsitoAccertamento> findAllByTipoPratica(@Param("tipoPratica") ETipoPratica tipoPratica, Pageable p)

}