package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivMorteCertificazioneRepository extends JpaRepository<CivMorteCertificazione, Long> {

    @Query("""SELECT a FROM CivMorteCertificazione a 
                  LEFT JOIN FETCH a.tipoAttoDomain t
                  LEFT JOIN FETCH t.categoriaDomain
                WHERE a.id = :id""")
    CivAttoBaseDomain findById(@Param("id") Long id)

    List<CivMorteCertificazione> findAllByIdIn(List<Long> ids)

    @Query("SELECT n.idAttoAnsc FROM CivMorteCertificazione n WHERE n.id = :id ")
    String findIdAttoAnsc(@Param("id") Long id)

}
