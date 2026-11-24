package it.finmatica.de4gsdzk.anagrafe.pratiche

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
interface AnaPraticaAllegatoRepository extends JpaRepository<AnaPraticaAllegato, Integer> {

    @Query(value = """SELECT a FROM AnaPraticaAllegato a
                        JOIN FETCH a.pratica
                        JOIN FETCH a.terminalista
                        WHERE a.pratica = :pratica""",
            countQuery = """SELECT count(a) FROM AnaPraticaAllegato a
                                JOIN a.pratica
                                WHERE a.pratica = :pratica""")
    Page<AnaPraticaAllegato> findByPratica(@Param("pratica") AnaPratica pratica, Pageable pageable)

    @Query(value = """SELECT c FROM AnaPraticaAllegato c 
                       INNER JOIN FETCH c.pratica p 
                       LEFT OUTER JOIN FETCH c.allegatoComunicazione
                       WHERE p.id = :idPratica AND c.allegatoComunicazione.id = :idComAlle """)
    AnaPraticaAllegato findByIdPraticaAndIdAllegatoComunicazione(@Param("idPratica") Long idPratica, @Param("idComAlle") Long idComAlle)

    @Modifying
    @Query("UPDATE AnaPraticaAllegato a SET a.note = :note WHERE a.id = :id")
    void updateNote(@Param(value = "id") Long id, @Param(value = "note") String note)

}