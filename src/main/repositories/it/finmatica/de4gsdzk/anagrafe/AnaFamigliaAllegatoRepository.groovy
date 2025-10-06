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
interface AnaFamigliaAllegatoRepository extends JpaRepository<AnaFamigliaAllegato, Integer> {

    @Query(value = """SELECT a FROM AnaFamigliaAllegato a
                        JOIN FETCH a.famiglia
                        WHERE a.famiglia = :famiglia""",
            countQuery = """SELECT count(a) FROM AnaFamigliaAllegato a
                                JOIN a.famiglia
                                WHERE a.famiglia = :famiglia""")
    Page<AnaFamigliaAllegato> findByFamiglia(@Param("famiglia") AnaFamiglia famiglia, Pageable pageable)

}