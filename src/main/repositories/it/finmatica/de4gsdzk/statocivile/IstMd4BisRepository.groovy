package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.IstMd4Bis
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface IstMd4BisRepository extends JpaRepository<IstMd4Bis, Long> {

    @Query("""SELECT c FROM IstMd4Bis c LEFT OUTER JOIN FETCH c.nazionalitaPadre LEFT OUTER JOIN FETCH c.nazionalitaMadre WHERE c.id = :id """)
    IstMd4Bis findById(@Param("id") Long id)

    @Query("""SELECT c FROM IstMd4Bis c LEFT OUTER JOIN FETCH c.nazionalitaPadre LEFT OUTER JOIN FETCH c.nazionalitaMadre WHERE c.idAtto = :identificativoAtto """)
    IstMd4Bis findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

}