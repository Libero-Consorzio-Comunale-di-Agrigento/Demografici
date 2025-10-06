package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaAnagrafeAllegatoRepository extends JpaRepository<AnaAnagrafeAllegato, Integer> {

    @Query(value = """SELECT a FROM AnaAnagrafeAllegato a
                        JOIN FETCH a.anagrafe
                        WHERE a.anagrafe = :anagrafe""",
            countQuery = """SELECT count(a) FROM AnaAnagrafeAllegato a
                                JOIN a.anagrafe
                                WHERE a.anagrafe = :anagrafe""")
    Page<AnaAnagrafeAllegato> findByAnagrafe(@Param("anagrafe") AnaAnagrafe anagrafe, Pageable pageable)

}