package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivTestoFormula
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivTestoFormulaRepository extends JpaRepository<CivTestoFormula, String> {

    CivTestoFormula findById(String id)

}