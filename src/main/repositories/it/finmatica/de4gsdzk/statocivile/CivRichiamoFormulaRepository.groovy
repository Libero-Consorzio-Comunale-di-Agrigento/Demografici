package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivRichiamoFormula
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivRichiamoFormulaRepository extends JpaRepository<CivRichiamoFormula, Long> {

    @Query("SELECT c FROM CivRichiamoFormula c JOIN FETCH c.formula f JOIN FETCH f.testo WHERE c.id = :id ")
    CivRichiamoFormula findById(@Param("id") Long id)

    @Query("""SELECT c FROM CivRichiamoFormula c 
                WHERE c.tipoAtto = :tipoAtto
                  AND c.formula = :formula """)
    List<CivRichiamoFormula> findAllByTipoAttoAndFormula(@Param("tipoAtto") Integer tipoAtto, @Param("formula") CivFormulaAnnotazione formula)

    @Query("""SELECT c FROM CivRichiamoFormula c JOIN FETCH c.formula f JOIN FETCH f.testo
               WHERE c.tipoAtto = :tipoAtto AND c.richiamo = :richiamo AND c.progressivo = :progressivo AND UPPER(f.id) LIKE UPPER(:filtro)
               ORDER BY c.richiamo, c.progressivo""")
    List<CivRichiamoFormula> findAllByTipoAttoAndRichiamoAndProgressivoAndFiltroLike(@Param("tipoAtto") Integer tipoAtto, @Param("richiamo") Integer richiamo,
                                                                       @Param("progressivo") Integer progressivo, @Param("filtro") String filtro)

    @Query("""SELECT f.descrizioneEstesa FROM CivRichiamoFormula c, CivFormulaAnnotazione f
               WHERE c.formula.id = f.id 
                 AND c.tipoAtto = :tipoAtto AND c.richiamo = :richiamo AND c.progressivo = :progressivo 
               ORDER BY c.richiamo, c.progressivo""")
    List<String> findAllFormuleByTipoAttoAndRichiamoAndProgressivo(@Param("tipoAtto") Integer tipoAtto, @Param("richiamo") Integer richiamo,
                                                                   @Param("progressivo") Integer progressivo)

}