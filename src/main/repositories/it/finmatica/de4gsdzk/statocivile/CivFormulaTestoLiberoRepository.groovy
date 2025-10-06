package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivFormulaTestoLibero
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivFormulaTestoLiberoRepository extends JpaRepository<CivFormulaTestoLibero, Long> {

    CivFormulaTestoLibero findById(Long id)

    @Query("""SELECT c FROM CivFormulaTestoLibero c WHERE c.idAtto = :identificativoAtto AND c.tipoAtto = :tipoAtto
                AND c.richiamo = :richiamo AND c.progressivo = :progressivo""")
    CivFormulaTestoLibero findByUkAttoAndTipoAttoAndRichiamoAndProgressivoMargine(@Param("identificativoAtto") String identificativoAtto,
                                                                                  @Param("tipoAtto") Integer tipoAtto, @Param("richiamo") Integer richiamo,
                                                                                  @Param("progressivo") Integer progressivo)

    @Query("""SELECT c FROM CivFormulaTestoLibero c WHERE c.idAtto = :identificativoAtto AND c.tipoAtto = :tipoAtto
              ORDER BY c.richiamo, c.progressivo""")
    List<CivFormulaTestoLibero> findAllByUkAttoAndTipoAtto(@Param("identificativoAtto") String identificativoAtto, @Param("tipoAtto") Integer tipoAtto)

    @Query("""SELECT c FROM CivFormulaTestoLibero c WHERE c.idAtto = :identificativoAtto
                AND c.richiamo NOT IN (:listaId) ORDER BY c.richiamo, c.progressivo""")
    List<CivFormulaTestoLibero> findAllByUkAttoAndRichiamoNotIn(@Param("identificativoAtto") String identificativoAtto, @Param("listaId") List<Integer> listaId)

    @Query("""SELECT c FROM CivFormulaTestoLibero c WHERE c.idAtto = :identificativoAtto
                AND c.richiamo IN (:listaId) ORDER BY c.richiamo, c.progressivo""")
    List<CivFormulaTestoLibero> findAllByUkAttoAndRichiamoIn(@Param("identificativoAtto") String identificativoAtto, @Param("listaId") List<Integer> listaId)

    @Query("""SELECT c FROM CivFormulaTestoLibero c WHERE c.idAtto = :identificativoAtto
                AND c.richiamo = :richiamo ORDER BY c.richiamo, c.progressivo""")
    List<CivFormulaTestoLibero> findAllByUkAttoAndRichiamo(@Param("identificativoAtto") String identificativoAtto, @Param("richiamo") Integer richiamo)

}