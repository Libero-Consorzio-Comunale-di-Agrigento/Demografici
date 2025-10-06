package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivParametroProtocollo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivParametroProtocolloRepository extends JpaRepository<CivParametroProtocollo, Long> {

    @Query(value = """SELECT c FROM CivParametroProtocollo c LEFT JOIN FETCH c.comunicazione WHERE c.id = :id """)
    CivParametroProtocollo findById(@Param("id") Long id)

    @Query(value = """SELECT c FROM CivParametroProtocollo c LEFT JOIN FETCH c.comunicazione 
                       WHERE c.codiceFase LIKE :codiceFase """,
            countQuery = """SELECT count(c) FROM CivParametroProtocollo c LEFT JOIN c.comunicazione 
                             WHERE c.codiceFase LIKE :codiceFase """)
    Page<CivParametroProtocollo> findAllByCodiceFase(@Param("codiceFase") String codiceFase, Pageable p)

}
