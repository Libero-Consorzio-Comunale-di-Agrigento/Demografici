package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anpr.AnpOperazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnpOperazioneRepository extends JpaRepository<AnpOperazione, String> {

    @Query(value = """SELECT o FROM AnpOperazione o
                        WHERE o.idOperazione = :idOperazione""",
            countQuery = """SELECT o FROM AnpOperazione o
                        WHERE o.idOperazione = :idOperazione""")
    Page<AnpOperazione> findAllByIdOperazione(@Param("idOperazione") Long idOperazione, Pageable pageable)

}