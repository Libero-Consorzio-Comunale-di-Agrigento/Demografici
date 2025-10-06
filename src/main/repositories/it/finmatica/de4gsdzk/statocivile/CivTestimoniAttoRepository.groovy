package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivTestimoniAtto
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivTestimoniAttoRepository extends JpaRepository<CivTestimoniAtto, Long> {

    @Query("""SELECT c FROM CivTestimoniAtto c
                       LEFT JOIN FETCH c.testimone1.nazionalita  
                       LEFT JOIN FETCH c.testimone2.nazionalita  
                       LEFT JOIN FETCH c.testimone3.nazionalita  
                       LEFT JOIN FETCH c.testimone4.nazionalita  
               WHERE c.idAtto = :identificativoAtto and c.tipoAtto = :tipoAtto """)
    CivTestimoniAtto findByUkAttoAndTipoAtto(@Param("identificativoAtto") String identificativoAtto, @Param("tipoAtto") Integer tipoAtto)

}