package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivFormulaAggiuntiva
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivFormulaAggiuntivaRepository extends JpaRepository<CivFormulaAggiuntiva, Long> {

    CivFormulaAggiuntiva findById(Long id)

    Page<CivFormulaAggiuntiva> findAllByTipoAttoOrderBySequenza(Integer tipoAtto, Pageable pageable)

}