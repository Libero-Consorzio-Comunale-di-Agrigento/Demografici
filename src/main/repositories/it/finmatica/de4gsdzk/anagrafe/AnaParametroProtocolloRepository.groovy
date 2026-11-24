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
interface AnaParametroProtocolloRepository extends JpaRepository<AnaParametroProtocollo, Long> {

    @Query(value = """SELECT a FROM AnaParametroProtocollo a 
                      LEFT JOIN FETCH a.modello 
                      WHERE a.id = :id """)
    AnaParametroProtocollo findById(@Param("id") Long id)

    @Query(value = """SELECT DISTINCT a FROM AnaParametroProtocollo a 
                      LEFT JOIN FETCH a.modello
                      WHERE a.codiceFase LIKE :codiceFase """,
            countQuery = """SELECT count(DISTINCT a) FROM AnaParametroProtocollo a
                             WHERE a.codiceFase LIKE :codiceFase """)
    Page<AnaParametroProtocollo> findAllByCodiceFase(@Param("codiceFase") String codiceFase, Pageable p)

    long countByFaseAndFunzione(String fase, String funzione)

}
