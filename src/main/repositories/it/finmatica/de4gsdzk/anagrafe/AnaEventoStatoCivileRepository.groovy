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
interface AnaEventoStatoCivileRepository extends JpaRepository<AnaEventoStatoCivile, Integer> {
    @Query(value = """SELECT e FROM AnaEventoStatoCivile e
               LEFT JOIN FETCH e.coniuge.anagrafe
              WHERE e.anagrafe = :anagrafe
            """,
            countQuery = """SELECT count(e) FROM AnaEventoStatoCivile e 
               LEFT JOIN e.coniuge.anagrafe
              WHERE e.anagrafe = :anagrafe
            """)
    Page<AnaEventoStatoCivile> findAllByAnagrafe(@Param("anagrafe") AnaAnagrafe anagrafe,
                                                 Pageable pageable)

    @Query("""SELECT count(e) FROM AnaEventoStatoCivile e
              WHERE e.anagrafe = :anagrafe
            """)
    long countByAnagrafe(@Param("anagrafe") AnaAnagrafe anagrafe)
}