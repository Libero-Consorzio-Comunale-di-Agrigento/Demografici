package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivSposiAtto
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivSposiAttoRepository extends JpaRepository<CivSposiAtto, Long> {

    @Query("""SELECT c FROM CivSposiAtto c WHERE c.idAtto = :identificativoAtto and c.tipoAtto = :tipoAtto """)
    CivSposiAtto findByUkAttoAndTipoAtto(@Param("identificativoAtto") String identificativoAtto, @Param("tipoAtto") Integer tipoAtto)

}