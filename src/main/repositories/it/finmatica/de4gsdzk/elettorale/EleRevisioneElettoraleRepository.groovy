package it.finmatica.de4gsdzk.elettorale


import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface EleRevisioneElettoraleRepository extends JpaRepository<EleRevisioneElettorale, String> {

    @Query(value = """SELECT r FROM EleRevisioneElettorale r
                        JOIN FETCH r.tipoRevisione
                        WHERE r.tipoRevisione.codice = 'BL'
                        AND r.dataVerbale IS NOT NULL
                        AND r.verbale IS NOT NULL""",
            countQuery = """SELECT count(r) FROM EleRevisioneElettorale r
                        WHERE r.tipoRevisione.codice = 'BL'
                        AND r.dataVerbale IS NOT NULL
                        AND r.verbale IS NOT NULL""")
    Page<EleRevisioneElettorale> findAll(Pageable p)


}