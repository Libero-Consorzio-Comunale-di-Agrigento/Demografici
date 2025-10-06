package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.IstMd3UUnioneCivile
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface IstMd3UUnioneCivileRepository extends JpaRepository<IstMd3UUnioneCivile, Long> {

    IstMd3UUnioneCivile findById(Long id)

    @Query("""SELECT c FROM IstMd3UUnioneCivile c WHERE c.idAtto = :identificativoAtto """)
    IstMd3UUnioneCivile findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

}