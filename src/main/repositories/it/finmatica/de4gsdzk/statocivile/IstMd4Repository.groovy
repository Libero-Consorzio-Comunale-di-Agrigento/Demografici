package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.IstMd4
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface IstMd4Repository extends JpaRepository<IstMd4, Long> {

    @Query("""SELECT c FROM IstMd4 c LEFT OUTER JOIN FETCH c.nazionalita WHERE c.id = :id """)
    IstMd4 findById(@Param("id") Long id)

    @Query("""SELECT c FROM IstMd4 c LEFT OUTER JOIN FETCH c.nazionalita WHERE c.idAtto = :identificativoAtto """)
    IstMd4 findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

}