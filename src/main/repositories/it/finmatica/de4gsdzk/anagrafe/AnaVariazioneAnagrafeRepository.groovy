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
interface AnaVariazioneAnagrafeRepository extends JpaRepository<AnaVariazioneAnagrafe, Integer> {

    @Query(value = """SELECT v FROM AnaVariazioneAnagrafe v
        LEFT JOIN FETCH v.utenteUpd
        LEFT JOIN FETCH v.nazionalita
        LEFT JOIN FETCH v.nazionalitaPrecedente
        LEFT JOIN FETCH v.viaPrecedente
        LEFT JOIN FETCH v.titoloStudioPrecedente
        LEFT JOIN FETCH v.titoloStudio
        LEFT JOIN FETCH v.professionePrecedente
        LEFT JOIN FETCH v.professione
        LEFT JOIN FETCH v.attivitaProfessionalePrecedente
        LEFT JOIN FETCH v.attivitaProfessionale
        LEFT JOIN FETCH v.posizioneProfessionalePrecedente
        LEFT JOIN FETCH v.posizioneProfessionale
        LEFT JOIN FETCH v.rapportoParentelaPrecedente
        LEFT JOIN FETCH v.rapportoParentela
        LEFT JOIN FETCH v.indirizzo.via
        WHERE v.anagrafe = :anagrafe
        AND (:includiPrivati = true OR v.privato IS NULL)""",
           countQuery = """SELECT COUNT(v) FROM AnaVariazioneAnagrafe v
        WHERE v.anagrafe = :anagrafe
        AND (:includiPrivati = true OR v.privato IS NULL)""")
    Page<AnaVariazioneAnagrafe> findAllByAnagrafe(@Param("anagrafe") AnaAnagrafe anagrafe,
                                                   @Param("includiPrivati") boolean includiPrivati,
                                                   Pageable pageable)

    @Query("""SELECT COUNT(v) FROM AnaVariazioneAnagrafe v
        WHERE v.anagrafe = :anagrafe
        AND (:includiPrivati = true OR v.privato IS NULL)""")
    long countByAnagrafe(@Param("anagrafe") AnaAnagrafe anagrafe,
                         @Param("includiPrivati") boolean includiPrivati)
}