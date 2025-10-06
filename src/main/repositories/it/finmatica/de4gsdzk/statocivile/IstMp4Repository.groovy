package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.IstMp4
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface IstMp4Repository extends JpaRepository<IstMp4, Long> {

    @Query("""SELECT c FROM IstMp4 c LEFT OUTER JOIN FETCH c.nazionalitaPadre LEFT OUTER JOIN FETCH c.nazionalitaMadre WHERE c.id = :id """)
    IstMp4 findById(@Param("id") Long id)

    @Query("""SELECT c FROM IstMp4 c LEFT OUTER JOIN FETCH c.nazionalitaPadre LEFT OUTER JOIN FETCH c.nazionalitaMadre WHERE c.idAtto = :identificativoAtto """)
    IstMp4 findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

}