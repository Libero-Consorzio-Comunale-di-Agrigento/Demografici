package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivFormulaChiusura
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivFormulaChiusuraRepository extends JpaRepository<CivFormulaChiusura, String> {

    List<CivFormulaChiusura> findAllByOrderById()

}