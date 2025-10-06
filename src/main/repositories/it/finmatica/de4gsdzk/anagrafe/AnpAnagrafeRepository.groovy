package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnpAnagrafeRepository extends JpaRepository<AnpAnagrafe, Long> {

    @Query(value = """SELECT c FROM AnpAnagrafe c 
                        LEFT OUTER JOIN FETCH c.nazionalita 
                        LEFT OUTER JOIN FETCH c.coniuge.nazionalita
                        LEFT OUTER JOIN FETCH c.padre
                        LEFT OUTER JOIN FETCH c.madre
                       WHERE c.idOperazione = :idOperazione 
                         AND (:sesso IS NULL OR c.sesso = :sesso) """,
            countQuery = """SELECT count(c) FROM AnpAnagrafe c 
                              LEFT OUTER JOIN c.nazionalita  
                              LEFT OUTER JOIN c.coniuge.nazionalita
                             WHERE c.idOperazione = :idOperazione 
                               AND (:sesso IS NULL OR c.sesso = :sesso) """)
    Page<AnpAnagrafe> findAllByIdOperazione(@Param("idOperazione") Long idOperazione, @Param("sesso") ESesso sesso, Pageable pageable)

}