package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivNotaFormula
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivNotaFormulaRepository extends JpaRepository<CivNotaFormula, Long> {

    @Query("SELECT c FROM CivNotaFormula c JOIN FETCH c.formula WHERE c.id = :id ")
    CivNotaFormula findById(@Param("id") Long id)

    @Query("SELECT c FROM CivNotaFormula c JOIN FETCH c.formula WHERE c.formula.id = :idFormula ")
    List<CivNotaFormula> findAllByFormula(@Param("idFormula") String idFormula)

    @Query("SELECT c FROM CivNotaFormula c JOIN FETCH c.formula WHERE c.formula.id = :idFormula ")
    List<CivNotaFormula> findAllByFormula(@Param("idFormula") String idFormula, Sort sort)

    @Query("SELECT c FROM CivNotaFormula c INNER JOIN c.formula WHERE c.formula.id = :idFormula AND c.variabile IN (:listaVariabili) ")
    List<CivNotaFormula> findAllByFormulaAndVariabileIn(@Param("idFormula") String idFormula, @Param("listaVariabili") List<Integer> listaVariabili)

}