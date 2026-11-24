package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anpr.AnpElettorale
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnpElettoraleRepository extends JpaRepository<AnpElettorale, String> {

    @Query(value = """SELECT e FROM AnpElettorale e
                        WHERE e.idOperazione = :idOperazione""",
            countQuery = """SELECT e FROM AnpElettorale e
                        WHERE e.idOperazione = :idOperazione""")
    Page<AnpElettorale> findAllByIdOperazione(@Param("idOperazione") Long idOperazione, Pageable pageable)

}