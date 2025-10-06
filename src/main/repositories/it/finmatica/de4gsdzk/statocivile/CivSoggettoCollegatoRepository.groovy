package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivSoggettoCollegato
import it.finmatica.de4gsdzk.utils.ETipoSoggettoCollegato
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivSoggettoCollegatoRepository extends JpaRepository<CivSoggettoCollegato, Long> {

    @Query("""SELECT c FROM CivSoggettoCollegato c 
                LEFT JOIN FETCH c.nazionalita
               WHERE c.idAtto = :identificativoAtto """)
    List<CivSoggettoCollegato> findAllByUkAtto(@Param("identificativoAtto") String identificativoAtto)

    @Query("""SELECT c FROM CivSoggettoCollegato c 
                LEFT JOIN FETCH c.nazionalita
               WHERE c.idAtto = :identificativoAtto AND c.tipoSoggettoCollegato = :tipoSoggettoCollegato """)
    CivSoggettoCollegato findByUkAttoAndTipoSoggettoCollegato(@Param("identificativoAtto") String identificativoAtto,
                                                              @Param("tipoSoggettoCollegato") ETipoSoggettoCollegato tipoSoggettoCollegato)

}