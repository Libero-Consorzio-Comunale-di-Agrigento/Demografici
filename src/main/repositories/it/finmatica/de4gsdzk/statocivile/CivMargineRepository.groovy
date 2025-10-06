package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivMargine
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivMargineRepository extends JpaRepository<CivMargine, Long> {

    @Query("""SELECT c FROM CivMargine c
                LEFT JOIN FETCH c.consolatoAffisione1
                LEFT JOIN FETCH c.consolatoAffisione2
              WHERE c.idAtto = :identificativoAtto """)
    CivMargine findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

}