package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaAnagrafeAllegatoRepository extends JpaRepository<AnaAnagrafeAllegato, Integer> {

    @Query(value = """SELECT a FROM AnaAnagrafeAllegato a
                        LEFT OUTER JOIN FETCH a.anagrafe
                        LEFT OUTER JOIN FETCH a.terminalista
                        WHERE a.anagrafe = :anagrafe""",
            countQuery = """SELECT count(a) FROM AnaAnagrafeAllegato a
                                JOIN a.anagrafe
                                WHERE a.anagrafe = :anagrafe""")
    Page<AnaAnagrafeAllegato> findByAnagrafe(@Param("anagrafe") AnaAnagrafe anagrafe, Pageable pageable)

    @Modifying
    @Query("UPDATE AnaAnagrafeAllegato a SET a.note = :note WHERE a.id = :id")
    void updateNote(@Param(value = "id") Long id, @Param(value = "note") String note)

}