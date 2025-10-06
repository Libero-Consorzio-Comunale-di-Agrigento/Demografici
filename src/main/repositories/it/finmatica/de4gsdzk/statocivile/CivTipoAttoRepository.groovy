package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.utils.ENaturaAtto
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivTipoAttoRepository extends JpaRepository<CivTipoAtto, Long>, CivTipoAttoCustomRepository {

    @Query(value = """SELECT c FROM CivTipoAtto c 
                        LEFT JOIN FETCH c.categoriaDomain LEFT OUTER JOIN FETCH c.tipoDocumentoFascicoloCia
                        WHERE c.id = :id """)
    CivTipoAtto findById(@Param("id") Long id)

    @Query(value = """SELECT c FROM CivTipoAtto c
                        WHERE c.tipoAtto = :tipoAtto
                        AND c.parte = :parte
                        AND (COALESCE(c.serie, :serie) IS NULL OR c.serie = :serie)
                        AND c.natura in (:ln)
                        AND (COALESCE(c.flagAnsc, :flagAnsc) IS NULL OR c.flagAnsc = :flagAnsc)
                        AND (c.flagPregresso = java.lang.Boolean.TRUE 
                            OR ((c.flagPregresso IS NULL OR c.flagPregresso = java.lang.Boolean.FALSE)
                                AND NOT EXISTS (
                                    SELECT 1 FROM CivTipoAtto b 
                                    WHERE b.tipoAtto = c.tipoAtto
                                    AND b.parte = c.parte
                                    AND COALESCE(b.serie, 'NOSERIE') = COALESCE(c.serie, 'NOSERIE')
                                    AND b.natura = c.natura
                                    AND b.flagAnsc = c.flagAnsc
                                    AND b.flagPregresso = java.lang.Boolean.TRUE                             
                                )
                            )
                        )""")
    CivTipoAtto findByFlagPregressoTrueAndTipoAttoAndParteAndSerieAndFlagAnscAndNaturaInList(@Param("tipoAtto") Integer tipoAtto,
                                                                                             @Param("parte") Integer parte,
                                                                                             @Param("serie") String serie,
                                                                                             @Param("flagAnsc") Boolean flagAnsc,
                                                                                             @Param("ln") List<ENaturaAtto> ln)

    @Query("""SELECT c FROM CivTipoAtto c 
                WHERE c.tipoAtto = :tipoAtto 
                  AND c.categoriaDomain.id = :idCategoria 
                  AND c.natura in (:ln) 
                  AND (COALESCE(c.flagAnsc, :flagAnsc) IS NULL OR c.flagAnsc = :flagAnsc)
                ORDER BY c.sequenza """)
    List<CivTipoAtto> findAllByTipoAttoAndCategoriaAndNaturaInListAndFlagAnsc(@Param("tipoAtto") Integer tipoAtto, @Param("idCategoria") Integer idCategoria, @Param("ln") List<ENaturaAtto> ln, @Param("flagAnsc") Boolean flagAnsc)

    @Query("""SELECT (COALESCE(MAX(SEQUENZA), 0) + 1) AS SEQUENZA FROM CivTipoAtto c WHERE c.tipoAtto = :tipoAtto """)
    Integer findMaxSequenzaByTipoAtto(@Param("tipoAtto") Integer tipoAtto)

}