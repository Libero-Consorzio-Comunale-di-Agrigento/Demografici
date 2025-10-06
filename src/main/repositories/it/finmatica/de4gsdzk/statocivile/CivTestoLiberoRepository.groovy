package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivTestoLibero
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivTestoLiberoRepository extends JpaRepository<CivTestoLibero, Long> {

    @Query("""SELECT c FROM CivTestoLibero c WHERE c.idAtto = :identificativoAtto """)
    CivTestoLibero findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

}