package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.IstMscDivorzio
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface IstMscDivorzioRepository extends JpaRepository<IstMscDivorzio, Long> {

    IstMscDivorzio findById(Long id)

    @Query("""SELECT c FROM IstMscDivorzio c WHERE c.idAtto = :identificativoAtto """)
    IstMscDivorzio findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

    @Query("""SELECT c.id FROM IstMscDivorzio c WHERE c.idAnnotazione = :idAnnotazione """)
    List<Long> findAllIdByIdAnnotazione(@Param("idAnnotazione") Long idAnnotazione)

}