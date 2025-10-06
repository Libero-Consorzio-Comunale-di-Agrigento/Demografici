package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicolo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivTipoDocumentoFascicoloRepository extends JpaRepository<CivTipoDocumentoFascicolo, Long> {

    @Query(value = """SELECT c FROM CivTipoDocumentoFascicolo c LEFT JOIN FETCH c.tipoAllegatoANSC WHERE c.id = :id """)
    CivTipoDocumentoFascicolo findById(@Param("id") Long id)

    CivTipoDocumentoFascicolo findByTipoAttoAndCodiceIgnoreCase(@Param("tipoAtto") Integer tipoAtto, @Param("codice") String codice)

    @Query(value = """SELECT c FROM CivTipoDocumentoFascicolo c LEFT OUTER JOIN FETCH c.tipoAllegatoANSC
                       WHERE c.tipoAtto = :tipoAtto
                         AND (:filtro IS NULL OR UPPER(COALESCE(c.descrizione, '%')) LIKE UPPER(:filtro)) 
                         AND (:ricorrente IS NULL OR c.flagRicorrente = :ricorrente) 
                         AND (:isPv IS NULL OR c.isProcessoVerbale = :isPv) 
                       ORDER BY c.descrizione """,
            countQuery = """SELECT count(c) FROM CivTipoDocumentoFascicolo c LEFT OUTER JOIN c.tipoAllegatoANSC
                             WHERE c.tipoAtto = :tipoAtto
                               AND (:filtro IS NULL OR UPPER(COALESCE(c.descrizione, '%')) LIKE UPPER(:filtro)) 
                               AND (:ricorrente IS NULL OR c.flagRicorrente = :ricorrente) 
                               AND (:isPv IS NULL OR c.isProcessoVerbale = :isPv) """)
    Page<CivTipoDocumentoFascicolo> findAllByTipoAttoAndIsProcessoVerbaleAndRicorrenteAndDescrizioneLikeOrderByDescrizione(@Param("tipoAtto") Integer tipoAtto,
                                                                                                                           @Param("isPv") Boolean isPv,
                                                                                                                           @Param("ricorrente") Boolean ricorrente,
                                                                                                                           @Param("filtro") String filtro, Pageable pageable)

}