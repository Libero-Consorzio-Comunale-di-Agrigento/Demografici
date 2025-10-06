package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.IstMd3Matrimonio
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface IstMd3MatrimonioRepository extends JpaRepository<IstMd3Matrimonio, Long> {

    IstMd3Matrimonio findById(Long id)

    @Query("""SELECT c FROM IstMd3Matrimonio c WHERE c.idAtto = :identificativoAtto """)
    IstMd3Matrimonio findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

}