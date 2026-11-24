package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivMatrimonioCertificazioneRepository extends JpaRepository<CivMatrimonioCertificazione, Long> {

    @Query("""SELECT a FROM CivMatrimonioCertificazione a 
                  LEFT JOIN FETCH a.tipoAttoDomain t
                  LEFT JOIN FETCH t.categoriaDomain
                WHERE a.id = :id""")
    CivAttoBaseDomain findById(@Param("id") Long id)

    List<CivMatrimonioCertificazione> findAllByIdIn(List<Long> ids)

    @Query("SELECT n.idAttoAnsc FROM CivMatrimonioCertificazione n WHERE n.id = :id ")
    String findIdAttoAnsc(@Param("id") Long id)

}
