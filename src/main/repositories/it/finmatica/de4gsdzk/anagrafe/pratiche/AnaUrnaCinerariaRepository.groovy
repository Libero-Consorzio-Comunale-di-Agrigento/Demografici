package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaUrnaCinerariaRepository extends JpaRepository<AnaUrnaCineraria, Long> {

    @Query("""SELECT u FROM AnaUrnaCineraria u
              WHERE u.anagrafe = :anagrafe
              ORDER BY u.dataMorte DESC""")
    List<AnaUrnaCineraria> findByMatricola(@Param("anagrafe") AnaAnagrafe anagrafe)


    @Query("""SELECT u FROM AnaUrnaCineraria u
              LEFT JOIN FETCH u.rapportoParentela
              LEFT JOIN FETCH u.anagrafe
              WHERE u.id = :id""")
    AnaUrnaCineraria findById(@Param("id") Long id)
}