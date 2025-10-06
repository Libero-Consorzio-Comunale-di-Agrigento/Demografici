package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivOcchiello
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivOcchielloRepository extends JpaRepository<CivOcchiello, Long> {

    @Query("""SELECT c FROM CivOcchiello c WHERE c.idAtto = :identificativoAtto """)
    CivOcchiello findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

}