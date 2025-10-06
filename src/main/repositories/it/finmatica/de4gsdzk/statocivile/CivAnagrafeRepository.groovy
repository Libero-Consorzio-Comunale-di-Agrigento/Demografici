package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivAnagrafe
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivAnagrafeRepository extends JpaRepository<CivAnagrafe, Long> {

    CivAnagrafe findById(Long id)

    @Query("""SELECT c FROM CivAnagrafe c WHERE c.idAtto = :identificativoAtto """)
    CivAnagrafe findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

    @Query("""SELECT c FROM CivAnagrafe c WHERE c.idAtto = :identificativoAtto and c.tipoAtto = :tipoAtto """)
    CivAnagrafe findByUkAttoAndTipoAtto(@Param("identificativoAtto") String identificativoAtto, @Param("tipoAtto") Integer tipoAtto)

}