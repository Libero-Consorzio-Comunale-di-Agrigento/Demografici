package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivCittadinanzaCertificazioneRepository extends JpaRepository<CivCittadinanzaCertificazione, Long> {

    @Query("""SELECT a FROM CivCittadinanzaCertificazione a 
                  LEFT JOIN FETCH a.tipoAttoDomain t
                  LEFT JOIN FETCH t.categoriaDomain
                WHERE a.id = :id""")
    CivAttoBaseDomain findById(@Param("id") Long id)

    @Query("SELECT n.idAttoAnsc FROM CivCittadinanzaCertificazione n WHERE n.id = :id ")
    String findIdAttoAnsc(@Param("id") Long id)

}
